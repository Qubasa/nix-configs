{ config, pkgs, ... }:
let
  suspend = pkgs.writeScript "suspend.sh" ''
    ${pkgs.systemd}/bin/systemctl suspend
  '';

  speak = text: pkgs.writeScript "speak.sh" ''
     ${pkgs.espeak}/bin/espeak -v en+whisper -s 110 "${text}"
    '';

  notify-script = pkgs.writeScript "notify.sh" ''
  #!/bin/sh
  DISPLAY=:0 ${pkgs.su}/bin/su ${config.mainUser} -c '${pkgs.libnotify}/bin/notify-send "   Battery is low" ""'
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
        ${speak "power level low"}
        ${notify-script}
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

  environment.systemPackages = with pkgs; [
    espeak
    ];

}
