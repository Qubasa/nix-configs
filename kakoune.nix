{ config, pkgs, lib, ... }:

let

unstable = import <nixos-unstable> {};

kak_lsp_conf = pkgs.writeText "kak-lsp.toml" ''
[language.typescript]
filetypes = ["typescript", "javascript"]
roots = ["package.json", "tsconfig.json"]
command = "javascript-typescript-stdio"

[language.python]
filetypes = ["python"]
roots = ["requirements.txt", "setup.py", ".git", ".hg"]
command = "pyls"
offset_encoding = "utf-8"

[language.c_cpp]
filetypes = ["c", "cpp"]
roots = ["compile_commands.json", ".cquery"]
command = "cquery"
args = ["--init={\"cacheDirectory\":\"/tmp/cquery\",\"highlight\":{\"enabled\":true}}"]

[language.bash]
filetypes = ["sh"]
roots = [".git", ".hg"]
command = "bash-language-server"
args = ["start"]

[language.latex]
filetypes = ["latex"]
roots = [".git"]
command = "texlab"

[language.go]
filetypes = ["go"]
roots = ["Gopkg.toml", "go.mod", ".git", ".hg"]
command = "gopls"
offset_encoding = "utf-8"
'';

kak_config = pkgs.writeText "kakrc" ''

 ${ builtins.readFile ./resources/kakrc }
'';
in
{


environment.systemPackages = with pkgs; [
    cquery
    python3
    (python37Packages.python-language-server.override {
	providers=["mccabe" "rope" "yapf" "pyflakes"];
    })
    nodePackages.javascript-typescript-langserver
    nodePackages.bash-language-server
    python37Packages.pyls-black
    python37Packages.pyls-isort
    python37Packages.pyls-mypy
    rls
    unstable.texlab # Latex language server
    unstable.kak-lsp
    (unstable.kakoune.override {
    configure = {
        plugins = with unstable.pkgs.kakounePlugins; [ 
          kak-powerline # Neat colored status bar
          kak-buffers # Easy buffer management
          kak-fzf # Intergrated fzf
        ];
     };
   })
];

system.activationScripts.copyKakouneConfig = ''

mkdir -p "${config.mainUserHome}"/.config/kak
ln -s -f ${kak_config} "${config.mainUserHome}"/.config/kak/kakrc

mkdir -p "${config.mainUserHome}"/.config/kak-lsp
ln -s -f ${kak_lsp_conf} "${config.mainUserHome}"/.config/kak-lsp/kak-lsp.toml

'';

}
