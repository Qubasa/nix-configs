# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let

unstable = import <nixos-unstable> {};

myMpv = pkgs.mpv.override {
    waylandSupport = true;
    x11Support = false;
    xineramaSupport = false;
    xvSupport = false;
    vulkanSupport = true;
  };

in
  {
    imports = [
      ./own-pkgs.nix
      ./hardware-configuration.nix
      ./hardware-specific.nix
      ./vpn-yubikey.nix
      ./aliases.nix
      ./window-manager.nix
      ./nvim.nix
      ./gnome-utility.nix
      ./zsh.nix
      ./theme.nix
      ./virtualisation.nix
      ./tmux.nix
      ./notify-daemon.nix
      ./users.nix
      ./options.nix
      ./power-action.nix
      ./security.nix
      ./networking.nix
      ./general.nix
      ./pass.nix
      # ./path-check.nix
      ./restic.nix
      ./hackedswitch.nix
      ./home-vpn.nix
      ./git.nix
      ./htop.nix
      ./firefox.nix
      ./ssh.nix
      ./font-config.nix
      ./tinc.nix
      ./terminal.nix
      ./quasselclient.nix
];

####################
#                  #
#     OPTIONS      #
#                  #
####################
mainUser = "lhebendanz";
mainUserHome = ''${config.users.extraUsers.${config.mainUser}.home}'';
secrets = "/root/secrets";
wallpapers = "/etc/nixos/resources/wallpapers";
screenlock_imgs = "/etc/nixos/resources/wallpapers";
gitEmail = "luis.nixos@gmail.com";
gitUser = "Luis Hebendanz";


programs.wireshark.enable = true;

# Add NUR packages from https://github.com/kalbasit/nur-packages
# nixpkgs.config.packageOverrides = pkgs: {
#     nur = import (builtins.fetchTarball rec {
#     url =  "https://github.com/nix-community/NUR/archive/238f96e78a2b9ee33750c0dbdc5123701a54d378.tar.gz";
#     sha256 = "1v7ngv673bxhq6scdfdhv975vsxi40jzg3hpb1vg042c7sp4y261";
#   })
#   {
#     inherit pkgs;
#   };
# };

environment.systemPackages = with pkgs; [

  ############################
  #                          #
  #   ONLY FREE PACKAGES     #
  #                          #
  ############################
  man-pages
  posix_man_pages # Use the posix standarized manpages with `man p <keyword>`

  wl-clipboard
  kanshi # dynamic display control for wayland
  wget
  git
  curl
  pwgen # generates passwords
  file
  nix-prefetch # Sha256sum a link for nixos
  ldns  # DNS tool
  alsaUtils # Console volume settings with alsamixer
  p7zip # Console archive tool
  fzf # fuzzy finder
  binutils # Binary inspection
  radare2 # Binary reversing
  nmap # Network discovery
  calc # Simple calculator
  tree # display files as tree
  gnupg # Email encryption
  ansible # Newest ansible automation tool
  nix-index # apt-file equivalent
  powertop # A power management tool
  libreoffice # Opening docs
  gimp # Editing pictures
  #deluge # torrent client
  thunderbird
  screen # For serial connections
  dos2unix # Convert win newlines to unix ones
  patchelf # Nixos packaging tool
  gdb # elf debugging
  moc # cli music streaming
  grim # Wayland screenshot tool
  ncdu # Disk usage
  taskwarrior # Task list
  veracrypt # Disk encryption tool
  powershell # Powershell for linux
  valgrind # c checker tool
  myMpv # Wayland compatbile mpv
  imv # Wayland compatible image viewer
  #unstable.wl-clipboard # Copy and paste from command line. Vim dependencies
  chromium
  evince # pdf reader
  sqlite-interactive # Sqlite cli

  # Java development
  eclipses.eclipse-sdk
  #eclipses.eclipse-modeling
  # astah-community

  # Network debugging
  traceroute
  tcpdump
  wireshark

  remmina # Remote Desktop application

  # Check internet speed
  speedtest-cli

  # Media
  obs-studio # Screen capturing
  ffmpeg-full # Convert video formats

  ## Rmount dependencies
  jq # Json parsing in shell
  cifs-utils # Samba mount
  sshfs # Mount a filesystem through ssh

  ############################
  #                          #
  #   ONLY UNFREE PACKAGES   #
  #                          #
  ############################
];

nixpkgs.config.allowUnfree = true;



# Exfat support
boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

# This value determines the NixOS release with which your system is to be
# compatible, in order to avoid breaking some software such as database
# servers. You should change this only after NixOS release notes say you
# should.
system.stateVersion = "19.03"; # Did you read the comment?

}
