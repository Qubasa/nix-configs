{config, pkgs, ...}:

let

  reverse_search = pkgs.writeText "zshrc" ''
    reverse_search()
    zle -N reverse_search
    reverse_search() zle -M "$(cat ~/.zsh_history | sed 's/^[^;]*;//g' | fzf --tac --no-sort)"
    bindkey '^r' reverse_search
  '';

  python_version = "3.7";
  nix_python_version = "python37Packages";


  direnvrc = pkgs.writeText "direnvrc" ''
# Usage: use nix_shell
#
# Works like use_nix, except that it's only rebuilt if the shell.nix or default.nix file changes.
# This avoids scenarios where the nix-channel is being updated and all the projects now need to be re-built.
#
# To force the reload the derivation, run `touch shell.nix`
use_nix() {
  local shellfile=shell.nix
  local wd=$PWD/.direnv/nix
  local drvfile=$wd/shell.drv
  local outfile=$ws/result

  # same heuristic as nix-shell
  if [[ ! -f $shellfile ]]; then
    shellfile=default.nix
  fi

  if [[ ! -f $shellfile ]]; then
    echo "use nix_shell: shell.nix or default.nix not found in the folder"
    exit
  fi

  if [[ -f $drvfile && $(stat -c %Y "$shellfile") -gt $(stat -c %Y "$drvfile") ]]; then
    log_status "use nix_shell: removing stale drv"
    rm "$drvfile"
  fi

  if [[ ! -f $drvfile ]]; then
    mkdir -p "$wd"
    # instanciate the drv like it was in a nix-shell
    IN_NIX_SHELL=1 nix-instantiate \
      --show-trace \
      --add-root "$drvfile" --indirect \
      "$shellfile" >/dev/null
  fi

  direnv_load nix-shell "$drvfile" --run "$(join_args "$direnv" dump)"
  watch_file "$shellfile"
}
  '';

in {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;

    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
eval "$(direnv hook zsh)"

# Created by newuser for 5.5.1
# # put this either in bashrc or zshrc
nixify() {
  if [ ! -e ./.envrc ]; then

    cat > .envrc << EOF
    use nix
    echo 'Entering Python Project Environment'

    # extra packages can be installed here
    unset SOURCE_DATE_EPOCH
    export PIP_PREFIX="\$(pwd)/.pip_packages"
    LOCAL_PIP="\$PIP_PREFIX/lib/python${python_version}/site-packages"

    python_path=(
    "\$LOCAL_PIP"
    "\$PYTHONPATH"
    )
    # use double single quotes to escape bash quoting
    IFS=: eval 'python_path="\''${python_path[*]}"'
    export PYTHONPATH="\$python_path"
    export MPLBACKEND='Qt4Agg'

    export PATH=\$PATH:\$PIP_PREFIX/bin

    # clear
EOF
    direnv allow
    ${pkgs.git}/bin/git init
    ${pkgs.git-secrets}/bin/git-secrets --install
  fi

  if [ ! -e default.nix ]; then
    cat > default.nix << EOF
      with import <nixpkgs> {};
      stdenv.mkDerivation {
      name = "env";
      buildInputs = [
        (with ${nix_python_version}; [
          pip
          ipython
          ])
      ];
      }
EOF

  if [ "$(grep -qxsF ".envrc" .gitignore)" != 0 ]; then
    echo ".envrc" >> .gitignore
  fi

  if [ "$(grep -qxsF ".direnv" .gitignore)" != 0 ]; then
    echo ".direnv" >> .gitignore
  fi

  if [ "$(grep -qxsF ".pip_packages" .gitignore)" != 0 ]; then
    echo ".pip_packages" >> .gitignore
  fi

  if [ "$(grep -qxsF "default.nix" .gitignore)" != 0 ]; then
    echo "default.nix" >> .gitignore
  fi

  git add .gitignore
  git commit -a -m "Added .gitignore"

  ''${EDITOR:-vim} default.nix
  fi
}

    '';

  loginShellInit = ''
      bindkey -e
      zstyle ":completion:*" special-dirs true
  '';

  shellInit = ''
    #disable config wizard
    zsh-newuser-install() { :; }
  '';

  ohMyZsh = {
    enable = true;
    theme = "gnzh";
    plugins = [
      "git"
    ];
  };

};

environment.systemPackages = with pkgs; [
  direnv
];

 environment.shellAliases.ns = "nix-shell --command zsh";

system.activationScripts.copyZshConfig = ''
    ln -f -s ${direnvrc} ${config.mainUserHome}/.zshrc
    chown -h ${config.mainUser}: ${config.mainUserHome}/.zshrc
'';


}
