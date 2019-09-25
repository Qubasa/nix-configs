{pkgs, config,  ...}:
let
  pycodestyle = pkgs.writeText "pycodestyle" ''
[pycodestyle]
max-line-length = 125
    '';

unstable = import <nixos-unstable> {};
in{


  environment.variables = {
    EDITOR = ["nvim"];
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs;{
    myNeovim = neovim.override
    {
      configure = {
        customRC = builtins.readFile ./vimrc.conf;

        packages.myVimPackage = with pkgs.vimPlugins;
        {
          # loaded on launch
          start = [
            nerdtree # file manager
            commentary # comment stuff out based on language
            fugitive # full git integration
            vim-airline-themes # lean & mean status/tabline
            vim-airline # status bar
            gitgutter # git diff in the gutter (sign column)
            vim-trailing-whitespace # trailing whitspaces in red
            tagbar # F3 function overview
            ReplaceWithRegister # For better copying/replacing
            polyglot # Language pack
            vim-indent-guides # for displaying indent levels
            deoplete-nvim # general autocompletion
            deoplete-go
            ale
            molokai # color scheme
          ];
          # manually loadable by calling `:packadd $plugin-name`
          opt = [];
          # To automatically load a plugin when opening a filetype, add vimrc lines like:
          # autocmd FileType php :packadd phpCompletion
        };
      };
    };
  };

  # Neovim dependencies
  environment.systemPackages = with pkgs; [
    ctags # dependencie
    myNeovim # neovim with custom config
    jq # For fixing json files
    xxd # .bin files will be displayed with xxd
    shellcheck # Shell linting
    ansible-lint # Ansible linting
    unzip # To vim into unzipped files
    nodePackages.jsonlint # json linting
    python3
    python36Packages.python-language-server # python linting
    python36Packages.pyls-mypy # Python static type checker
    python36Packages.black # Python code formatter
    python37Packages.libxml2 # For fixing yaml files
    ccls # C/C++ language server
    clang-tools # C++ fixer
    cargo

    # Go support
    go
    gotools
    gocode
  ];


  system.activationScripts.copyNvimConfig = ''
      ln -f -s ${pycodestyle} ${config.mainUserHome}/.config/pycodestyle
      chown -h ${config.mainUser}: ${config.mainUserHome}/.config/pycodestyle

  '';
}

