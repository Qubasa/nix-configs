# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
 # unstable = import <nixos-unstable> { };
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
      ./dunst.nix
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
      ./termite.nix
      ./quasselclient.nix
      ./firejail.nix
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

environment.systemPackages = with pkgs; [

  ############################
  #                          #
  #   ONLY FREE PACKAGES     #
  #                          #
  ############################
  man-pages
  xorg.xorgdocs
  posix_man_pages # Use the posix standarized manpages with `man p <keyword>`


  nix-prefetch # Sha256sum a link for nixos
  ldns  # DNS tool
  ncdu # Disk usage profiler
  feh # Image viewer
  moc # Console Music Player
  alsaUtils # Console volume settings with alsamixer
  p7zip # Console archive tool
  fzf # fuzzy finder
  qrencode # Generate qrcodes out of strings
  wget
  git
  curl
  file
  binutils # Binary inspection
  radare2 # Binary reversing
  nmap # Network discovery
  calc # Simple calculator
  tree
  gnupg # Email encryption
  ansible # Newest ansible automation tool
  nix-index # apt-file equivalent
  powertop # A power management tool
  libreoffice # Opening docs
  gimp # Editing pictures
  #deluge # torrent client
  screen # For serial connections
  dos2unix # Convert win newlines to unix ones
  xorg.xev # Capture keyboard inputs and print key name
  patchelf # Nixos packaging tool
  gdb
  taskwarrior # A task manager tool
  veracrypt # Disk encryption tool
  powershell # Powershell for linux
  valgrind # c checker tool
  firejail # Containerisation tool for apps
  wl-clipboard # Copy and paste from command line. Vim dependencie!

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
  mpv # Video playback
  obs-studio # Screen capturing
  ffmpeg-full # Convert video formats

  ## Rmount dependencies
  jq # Json parsing in shell
  cifs-utils # Samba mount
  sshfs # Mount a filesystem through ssh

  # Icons (Fallback)
  gnome3.adwaita-icon-theme
  gnome2.gnome_icon_theme
  hicolor_icon_theme

  ############################
  #                          #
  #   ONLY UNFREE PACKAGES   #
  #                          #
  ############################
];

nixpkgs.config.allowUnfree = true;


# Exfat support
#boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

# This value determines the NixOS release with which your system is to be
# compatible, in order to avoid breaking some software such as database
# servers. You should change this only after NixOS release notes say you
# should.
system.stateVersion = "19.03"; # Did you read the comment?

}
