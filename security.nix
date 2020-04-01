{ pkgs, config, lib, ... }:

with lib;

{
  # Import hardening profile here
  # override some changes down below
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
  imports = [
    <nixpkgs/nixos/modules/profiles/hardened.nix>
    ./modules/apparmor.nix
  ];
  disabledModules = [ "security/apparmor.nix"  ];

  security.apparmor = {
   enable = true;
   profiles = [
    ./resources/apparmor/firefox.armor
    ./resources/apparmor/plugin-container.armor
   ];
   };

  # This is done so that we can store our apparmor profiles in
  # resources but we can still use aa-logprof to automatically
  # update our profiles
  system.activationScripts.copyApparmor = ''
    FOLD="/etc/nixos/resources/apparmor"
    if [ ! -d "$FOLD"  ]; then
      echo "Missing folder $FOLD"
      exit -1
    fi

    cp -r /etc/apparmor.d/abstractions /etc/nixos/resources/apparmor/
    cp -r /etc/apparmor.d/tunables /etc/nixos/resources/apparmor/
  '';

  # Disable this if you have problems with
  # drivers that do not load
  security.lockKernelModules = false;

  # if disabled you loose 30% of cpu power
  security.allowSimultaneousMultithreading = true;

  # Clearing cache makes your cpu veery slow
  security.virtualisation.flushL1DataCache = "never";

  security.allowUserNamespaces = true;

  # Auto upgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "0/3:00:00"; # Check every 3 hours for updates

  # Check for updates 5 minutes after restart
  # systemd.timers."nixos-upgrade".timerConfig = {
  #   OnBootSec="5min";
  # };

  hardware.bluetooth.enable = false;

  security.polkit.enable = true;

  # Set sudo timeout to 30 mins
  security.sudo = {
    enable = true;
    extraConfig = "Defaults        env_reset,timestamp_timeout=30";
  };

  # List of users/@groups that are allowed to connect to the Nix daemon
  nix.allowedUsers = ["${config.mainUser}"];


  # Disabled because usbguard applet has been deprecated: https://github.com/USBGuard/usbguard/issues/334
  # Only allow specific usb devices
  # services.usbguard.enable = true;
  # services.usbguard.IPCAllowedUsers = [ "root" config.mainUser ];
  # services.usbguard.ruleFile = "${config.secrets}/usbguard/rules.conf";

  # systemd.user.services.usbguard-applet = {
  #   description = "USBGuard applet";
  #   partOf = [ "graphical-session.target" ];
  #   wantedBy = [ "graphical-session.target" ];
  #   path = [ "/run/current-system/sw/" ]; ### Fix empty PATH to find qt plugins
  #   serviceConfig = {
  #     ExecStart = "${pkgs.usbguard}/bin/usbguard-applet-qt";
  #     Restart = "always";
  #   };
  # };


  # Check if secrets are all non world readable
  system.activationScripts."check-permissions" = ''
    FOUND=$(find ${config.secrets} -type f -and ! -user root -or -type f -and ! -group root -or -type f -and -perm /o+r+w)
    if [ "$FOUND" != "" ]; then
      echo -e "\e[31mERROR: These files $FOUND \nare world readable / writeable!\e[39m"
    fi
    '';

  # Option for less to run in secure mode
  environment.variables = {
    LESSSECURE = [ "1" ];
  };

  boot.kernelParams = [
   # Against Row-Hammer attack
   # will cause the kernel to panic on any uncorrectable ECC errors detected
   "mce=0"
  ];

}
