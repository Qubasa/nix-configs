{ config, pkgs, lib, ... }:

let

unstable = import <nixos-unstable> {};

kak_config = pkgs.writeText "kakrc" ''

 ${ builtins.readFile ./resources/kakrc }
'';
in
{


environment.systemPackages = with pkgs; [
 ccls

    (python37Packages.python-language-server.override {
	providers=["mccabe" "rope" "yapf" "pyflakes"];
    })
    python37Packages.pyls-black
    python37Packages.pyls-isort
    python37Packages.pyls-mypy
    rls
    kak-lsp
    (kakoune.override {
    configure = {
        plugins = with pkgs.kakounePlugins; [ 
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

'';

}
