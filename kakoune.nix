{ config, pkgs, lib, ... }:

let

unstable = import <nixos-unstable> {};

kak_lsp_conf = pkgs.writeText "kak-lsp.toml" ''
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
    python37Packages.pyls-black
    python37Packages.pyls-isort
    python37Packages.pyls-mypy
    rls
    unstable.kak-lsp
    (unstable.kakoune.override {
    configure = {
        plugins = with unstable.pkgs.kakounePlugins; [ 
          kak-powerline
          kak-buffers # Easy buffer management
          kak-auto-pairs # Auto close parenthesis
          kak-fzf # Intergrated fzf
        ];
     };
   })
];

system.activationScripts.copyKakouneConfig = ''

 mkdir -p "${config.mainUserHome}"/.config/kak
 ln -s -f ${kak_config} "${config.mainUserHome}"/.config/kak/kakrc

# mkdir -p "${config.mainUserHome}"/.config/kak-lsp
# ln -s -f ${kak_lsp_conf} "${config.mainUserHome}"/.config/kak-lsp/kak-lsp.toml

'';

}
