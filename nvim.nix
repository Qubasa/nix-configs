{pkgs, config,  ...}:
let
  coc_config = pkgs.writeText "coc-settings.json" ''
      {

    "coc.preferences.useQuickfixForLocations":true,
    "languageserver": {
        "golang": {
          "command": "gopls",
          "rootPatterns": ["go.mod"],
          "filetypes": ["go"]
        },
        "python": {
          "command": "pyls",
          "args": [
            "-vv",
            "--log-file",
            "/tmp/lsp_python.log"
          ],
          "trace.server": "verbose",
          "filetypes": [
            "python"
          ],
          "settings": {
            "pyls": {
              "enable": true,
              "trace": {
                "server": "verbose"
              },
              "commandPath": "",
              "configurationSources": [
                "pylint"
              ],
              "plugins": {
                "autopep8":{
                  "enabled": false
                },
                "pylint": {
                  "enabled": true,
                  "match": "(?!test_).*\\.py",
                  "matchDir": "[^\\.].*"
                },
                "jedi_completion": {
                  "enabled": true
                },
                "jedi_hover": {
                  "enabled": true
                },
                "jedi_references": {
                  "enabled": true
                },
                "jedi_signature_help": {
                  "enabled": true
                },
                "jedi_symbols": {
                  "enabled": true,
                  "all_scopes": true
                },
                "mccabe": {
                  "enabled": true,
                  "threshold": 15
                },
                "preload": {
                  "enabled": true
                },
                "pycodestyle":{
                    "enabled":false
                },
                "pydocstyle": {
                  "enabled": false,
                  "match": "(?!test_).*\\.py",
                  "matchDir": "[^\\.].*"
                },
                "pyflakes": {
                  "enabled": false
                },
                "rope_completion": {
                  "enabled": true
                },
                "yapf": {
                  "enabled": true
                }
              }
            }
          }
        },
        "ccls": {
            "command": "ccls",
            "filetypes": [
                "c",
                "cpp",
                "objc",
                "objcpp"
            ],
            "rootPatterns": [
                ".ccls",
                "compile_commands.json",
                ".vim/",
                ".git/",
                ".hg/"
            ],
            "initializationOptions": {
                "cache": {
                    "directory": "/tmp/ccls"
                }
            }
        }
    }
}
  '';

unstable = import <nixos-unstable> {};
in{


  environment.variables = {
    EDITOR = ["nvim"];
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs;{
    myNeovim = unstable.neovim.override
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
            gitgutter # git diff in the gutter (sign column)
            vim-trailing-whitespace # trailing whitspaces in red
            tagbar #  function overview window
            ReplaceWithRegister # For better copying/replacing
            polyglot # Language pack
            vimPlugins.indentLine
            vimPlugins.coc-html
            vimPlugins.coc-css
            vimPlugins.coc-nvim
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
    nodejs # coc dependencie
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
    unstable.gotools
    go
  ];

  environment.etc."pylintrc" = {
    text = ''
      [MESSAGES CONTROL]
      disable=missing-docstring, no-else-return, broad-except, no-member
      max-line-length=125
      '';
  };


  system.activationScripts.copyNvimConfig = ''

      mkdir -p ${config.mainUserHome}/.config/nvim
      ln -f -s ${coc_config} ${config.mainUserHome}/.config/nvim/coc-settings.json
      chown -R ${config.mainUser}: ${config.mainUserHome}/.config/nvim
  '';
}

