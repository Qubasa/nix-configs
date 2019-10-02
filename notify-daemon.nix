{ config, pkgs, lib, ... }:

let

  mako_config = pkgs.writeText "mako-config" ''
    font=DejaVu Sans Mono 12

    background-color=#000000
    text-color=#ffffff

    border-size=3
    border-color=#db7508

    [urgency=low]
    background-color=#282c30
    text-color=#888888
    default-timeout=2000

    [urgency=normal]
    background-color=#282c30
    text-color=#ffffff
    default-timeout=3000

    [urgency=high]
    background-color=#900000
    text-color=#ffffff
    border-color=#ff0000
    default-timeout=0

    '';

in {

  systemd.user.services.mako = {
    enable = true;
    description =  "Mako notification daemon" ;
    after = [ "sway-session.target" ];
    wants = [ "sway-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mako}/bin/mako";
    };

  };



environment.systemPackages = with pkgs; [
  mako
  libnotify
];



system.activationScripts.copyMakoConfig = ''

    mkdir -p ${config.mainUserHome}/.config/mako
    ln -f -s ${mako_config} ${config.mainUserHome}/.config/mako/config
    chown -R ${config.mainUser}: ${config.mainUserHome}/.config/mako

'';
}
