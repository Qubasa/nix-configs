{ config, pkgs, ... }:
{

# Enable printing (how to disable service listening on all interfaces?)
services.printing.enable = true;
services.printing.drivers = [
  pkgs.gutenprint
  pkgs.gutenprintBin
];


# Activate audio output
hardware.pulseaudio.enable = true;

# Select internationalisation properties.
i18n = {
  consoleFont = "Monospace";
  consoleKeyMap = "de";
  defaultLocale = "en_US.UTF-8";
};

time.timeZone = "Europe/Berlin";

# Can create USB issues
#powerManagement.powertop.enable = true;


}
