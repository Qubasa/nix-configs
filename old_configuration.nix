# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ self, config, pkgs, lib,  ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-specific.nix
    ./security.nix
    ./firefox.nix
    ./chromium.nix
    ./packages.nix
    ./options.nix
    ./networking.nix
    ./display.nix
    ./editor.nix
    ./virtualisation.nix
    ./pass.nix
    ./terminal.nix
    ./own-pkgs.nix
    ./aliases.nix
    ./restic.nix
    ./retiolum_vpn.nix
    ./envfs.nix
    ./pipewire.nix
    ./printing.nix
    ./unbound.nix
    ./server_decrypt.nix
  ];

  nixpkgs.config.allowUnfree = true;


  # Options
  mainUser = "lhebendanz";
  mainUserHome = ''${config.users.extraUsers.${config.mainUser}.home}'';
  secrets = "/root/secrets";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.${config.mainUser} = rec {
    name = config.mainUser;
    initialPassword = name;
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "adbuser" "wheel" "networkmanager" "video" "audio" "input" "wireshark" "dialout" "disk" "scanner" "lp" "plugdev" "hp" ];
  };

  # Language settings
  console.keyMap = "de";
  console.font = "Monospace";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";


  # Android ADB
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];


  # nix daemon optimizations
  # fetchtarball ttl set to one week
  # enabled flakes
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 15d";
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true       # Nice for developers
      tarball-ttl = 4294967295
    '';
  };



  # Exfat support
  #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  boot.supportedFilesystems = [ "ntfs" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

}
