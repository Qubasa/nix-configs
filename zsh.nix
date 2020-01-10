{config, pkgs, ...}:

let

  nix_python_version = "python37Packages";
  python_version_long = "3.7.5";
  python_version = "3.7";


  mic_direnv_rc =("${pkgs.fetchFromGitHub {
      owner = "Mic92";
      repo = "dotfiles";
      rev = "a0a9b7e358fa70a85cd468f8ca1fbb02ae0a91df";
      sha256 = "1y9h5s1lf59sczsm0ksq2x1yhl98ba9lwk5yil3q53rg7n4574pg";
    }}/home/.direnvrc");

  direnv_rc = pkgs.writeText "direnvrc" ''
    # ${mic_direnv_rc}
    ${builtins.readFile mic_direnv_rc}

    realpath() {
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/''${1#./}"
    }
    layout_python-venv() {
        local python=''${1:-python3}
        [[ $# -gt 0 ]] && shift
        unset PYTHONHOME
        if [[ -n $VIRTUAL_ENV ]]; then
            VIRTUAL_ENV=$(realpath "''${VIRTUAL_ENV}")
        else
            local python_version
            python_version=$("$python" -c "import platform; print(platform.python_version())")
            if [[ -z $python_version ]]; then
                log_error "Could not detect Python version"
                return 1
            fi
            VIRTUAL_ENV=$PWD/.direnv/python-venv-$python_version
        fi
        export VIRTUAL_ENV
        if [[ ! -d $VIRTUAL_ENV ]]; then
            log_status "no venv found; creating $VIRTUAL_ENV"
            "$python" -m venv "$VIRTUAL_ENV"
        fi
        PATH_add "$VIRTUAL_ENV/bin"
    }
    '';

 nixify = pkgs.writers.writeDashBin "nixify" ''
  set -efuC
  if [ ! -e ./.envrc ]; then
    cat > .envrc <<'EOF'
    use_nix
    layout python-venv
    export PYTHONPATH=".:$PWD/.direnv/python-venv-${python_version_long}/lib/${python_version}/site-packages:$PYTHONPATH"
EOF
    direnv allow
  fi
  if [ ! -e shell.nix ]; then
    cat > shell.nix <<'EOF'
  { pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = with pkgs; [
      (with ${nix_python_version}; [
        pip
        ipython
      ])

    ];
    shellHook = "export HISTFILE=''${toString ./.history}";
  }
EOF
  fi

  if [ "$(grep -qxsF ".envrc" .gitignore)" != 0 ]; then
    echo ".envrc" >> .gitignore
  fi
  if [ "$(grep -qxsF ".direnv" .gitignore)" != 0 ]; then
    echo ".direnv" >> .gitignore
  fi

  if [ "$(grep -qxsF ".history" .gitignore)" != 0 ]; then
    echo ".history" >> .gitignore
  fi
  if [ "$(grep -qxsF ".__pycache__" .gitignore)" != 0 ]; then
    echo ".__pycache__" >> .gitignore
  fi
  git init
  git add .gitignore
  git commit -m "Added .gitignore"

  ''${EDITOR:-kak} shell.nix
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
  nixify
];

system.activationScripts.copyZshConfig = ''
    touch ${config.mainUserHome}/.zshrc
    ln -f -s ${direnv_rc} ${config.mainUserHome}/.direnvrc
    chown -h ${config.mainUser}: ${config.mainUserHome}/.direnvrc
'';


}
