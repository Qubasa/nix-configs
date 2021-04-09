{pkgs, ...}:


let
  myUnstable = import <nixos-unstable>{};

in {
 environment.variables = {
    EDITOR = ["nvim"];
    VISUAL = ["nvim"];
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs;{
    myNeovim = myUnstable.neovim.override
    {
      configure = {
        customRC = builtins.readFile ./resources/vimrc.conf;

        packages.myVimPackage =
        {
          # loaded on launch
          start = with pkgs.vimPlugins; [
            commentary # comment stuff out based on language
            vim-airline-themes # lean & mean status/tabline
            vim-airline # status bar
            vim-trailing-whitespace # trailing whitspaces in red
            tagbar #  function overview window
            polyglot # Language pack
            indentLine # Shows indendation level
            fzf-vim
            fugitive # vim git integration
            molokai # color scheme
            myUnstable.vimPlugins.ale # Language server integration
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
    ctags # dependencie for tagbar
    myNeovim # neovim with custom config
    jq # For fixing json files
    shellcheck # Shell linting
    ansible-lint # Ansible linting
    unzip # To vim into unzipped files
    xxd # Show binary as hex
    nodePackages.jsonlint # json linting
    (python3.withPackages (pypkgs: with pkgs.python37Packages; [
      black
      # requests
      python-language-server
      # capstone how to fix gef?
      # ropper
      # unicorn
    ]))
    ccls # C/C++ language server
    clang-tools # C++ fixer
    nodePackages.prettier # Typescript formatter
    cscope # Interactive c code browser for huge codebases
  ];

  environment.etc."pylintrc" = {
    text = ''
      [MESSAGES CONTROL]
      disable=missing-docstring, no-else-return, broad-except, no-member, global-statement, invalid-name, logging-fstring-interpolation
      max-line-length=125
      '';
  };

}
