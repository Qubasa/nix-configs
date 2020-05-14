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
console.keyMap = "de";
console.font = "Monospace";
i18n = {
  defaultLocale = "en_US.UTF-8";
};

time.timeZone = "Europe/Berlin";
programs.gnupg.agent = {
  pinentryFlavor = "gnome3";
  enable = true;
};
# Can create USB issues
#powerManagement.powertop.enable = true;


}
