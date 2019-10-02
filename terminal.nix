{pkgs, config, lib, ...}:

let

unstable = import <nixos-unstable> {};

alacritty_config = pkgs.writeText "config" ''
program: ${pkgs.zsh}/bin/zsh
args:
  - --login

scrolling:
  history: 100000

font:
  family: Bitstream Vera Sans
  size: 14.0


colors:
  # Default colors
  primary:
    background: '0x2b2b2b'
    foreground: '0xdedede'

  # Normal colors
  normal:
    black:   '0x2e3436'
    red:     '0xcc0000'
    green:   '0x4e9a06'
    yellow:  '0xc4a000'
    blue:    '0x3465a4'
    magenta: '0x75507b'
    cyan:    '0x06989a'
    white:   '0xd3d7cf'

  # Bright colors
  bright:
    black:   '0x555753'
    red:     '0xef2929'
    green:   '0x8ae234'
    yellow:  '0xfce94f'
    blue:    '0x729fcf'
    magenta: '0xad7fa8'
    cyan:    '0x34e2e2'
    white:   '0xeeeeec'
  '';

in {

  environment.systemPackages = with pkgs; [
    unstable.alacritty
    unstable.alacritty.terminfo
  ];

  environment.variables = {
    TERM = [ "xterm-256color" ];
  };

  system.activationScripts.copyTermiteConfig = ''
      mkdir -p ${config.mainUserHome}/.config/alacritty
      ln -f -s ${alacritty_config} ${config.mainUserHome}/.config/alacritty/alacritty.yml
      chown -R ${config.mainUser}: ${config.mainUserHome}/.config/alacritty
  '';
}
