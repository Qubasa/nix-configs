{pkgs, ...}:

{
 environment.variables = {
    EDITOR = ["nvim"];
    VISUAL = ["nvim"];
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs;{
    myNeovim = pkgs.neovim.override
    {
      configure = {
        customRC = builtins.readFile ./resources/vimrc.conf;

        packages.myVimPackage = with pkgs.vimPlugins;
        {
          # loaded on launch
          start = [
            commentary # comment stuff out based on language
            vim-airline-themes # lean & mean status/tabline
            vim-airline # status bar
            vim-trailing-whitespace # trailing whitspaces in red
            tagbar #  function overview window
            polyglot # Language pack
            vimPlugins.indentLine
            vimPlugins.fugitive
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
    ctags # dependencie for tagbar
    myNeovim # neovim with custom config
    jq # For fixing json files
    shellcheck # Shell linting
    ansible-lint # Ansible linting
    unzip # To vim into unzipped files
    xxd # Show binary as hex
    nodePackages.jsonlint # json linting
    python3
    python37Packages.jedi
    python37Packages.python-language-server # python linting
    python37Packages.pyls-mypy # Python static type checker
    python37Packages.pylint # Python linter
    python37Packages.black # Python code formatter
    python37Packages.libxml2 # This is Xmllint
    ccls # C/C++ language server
    clang-tools # C++ fixer
  ];

  environment.etc."pylintrc" = {
    text = ''
      [MESSAGES CONTROL]
      disable=missing-docstring, no-else-return, broad-except, no-member, global-statement, invalid-name
      max-line-length=125
      '';
  };

}
