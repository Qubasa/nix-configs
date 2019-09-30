{pkgs, config, lib, ... }:
let

  xresources = pkgs.writeText "Xresources" ''
    Xcursor.size: 16
    '';
in {
    hardware.trackpoint = { # The red button in the middle of the keyboard
    enable = true;
    sensitivity = 300;
    speed = 0;
    emulateWheel = true;
  };

  # services.xserver.synaptics = {
  #   enable = true;
  #   maxSpeed = "1.7";
  #   minSpeed = "1";
  #   accelFactor = "0.02";
  #   tapButtons = true;
  #   vertTwoFingerScroll = true;
  #   horizTwoFingerScroll = true;
  #   palmDetect = true;
  # };


  system.activationScripts.copyMouseConfig = ''
      CONFIG_FOLDER=${config.mainUserHome}
      CONFIG_FILE_PATH=$CONFIG_FOLDER/.Xresources
      ln -f -s ${xresources} $CONFIG_FILE_PATH
      chown -h ${config.mainUser}: $CONFIG_FILE_PATH
  '';
}

