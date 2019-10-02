{ config, pkgs, ... }:
let
  suspend = pkgs.writeScript "suspend.sh" ''
    ${pkgs.systemd}/bin/systemctl suspend
  '';

  speak = text: pkgs.writeScript "speak.sh" ''
     ${pkgs.espeak}/bin/espeak -v en+whisper -s 110 "${text}"
    '';

  notify-script = pkgs.writeScript "notify.sh" ''
    #!/bin/sh -e

    export PATH=$PATH:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:${pkgs.procps}/bin:${pkgs.findutils}/bin:${pkgs.gnused}/bin

    SWAY_PID=$(ps -U $USER | grep sway-wrapped | awk '{ print $1  }')
    DBUS_SESSION_BUS_ADDRESS=$(xargs -0 -L1 -a "/proc/$SWAY_PID/environ" | grep "DBUS_SESSION_BUS_ADDRESS=" | sed 's/DBUS_SESSION_BUS_ADDRESS=//')
    export DBUS_SESSION_BUS_ADDRESS

    ${pkgs.libnotify}/bin/notify-send "   Battery is low" ""
  '';



in {
  imports =
  [ # Include the results of the hardware scan.
    ./modules/power-action.nix
  ];

  krebs.power-action = {
    user = "${config.mainUser}";

    enable = true;
    plans.low-battery = {
      upperLimit = 10;
      lowerLimit = 5;
      charging = false;
      action = pkgs.writeScript "warn-low-battery" ''
        #!/bin/sh
        ${notify-script}
        ${speak "power level low"}
      '';
    };
    plans.suspend = {
      upperLimit = 10;
      lowerLimit = 0;
      charging = false;
      action = pkgs.writeScript "suspend-wrapper" ''
        #!/bin/sh
        ${suspend}
      '';
    };
  };

}
