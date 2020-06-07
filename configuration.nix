# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let

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
      ./nix_test.nix
      ./hardware-configuration.nix
      ./hardware-specific.nix
      ./general-vpn.nix
      ./aliases.nix
      ./window-manager.nix
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
      ./nur_packages.nix
      ./unstable.nix
      ./vim.nix
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
  posix_man_pages # Use the posix standarized manpages with `man p <keyword>`

  ranger
  pciutils
  wget
  git
  curl
  pwgen # generates passwords
  file
  nix-prefetch # Sha256sum a link for nixos
  ldns  # DNS tool
  alsaUtils # Console volume settings with alsamixer
  p7zip # Console archive tool
  unzip
  fzf # fuzzy finder
  binutils # Binary inspection
  radare2 # Binary reversing
  unstable.radare2-cutter # QT GUI for radare2
  ghidra-bin
  nmap # Network discovery
  calc # Simple calculator
  chromium
  # (chromium.override {
  #   useOzone = true;
  # })
  tree # display files as tree
  gnupg # Email encryption
  nix-index # apt-file equivalent
  ansible
  docker-compose
  discord # Centralized chat platform
  cargo-watch # Rust on demand recompile
  pkgs.unstable.pkgs.insomnia # REST API client
  powertop # A power management tool
  libreoffice # Opening docs
  gimp # Editing pictures
  #deluge # torrent client
  bat # Cat with syntax highlighting
  thunderbird
  # close it with strg+a & strg+q
  dos2unix # Convert win newlines to unix ones
  gdb # elf debugging
  moc # cli music streaming
  grim # Wayland screenshot tool
  ncdu # Disk usage
  taskwarrior # Task list
  veracrypt # Disk encryption tool
  valgrind # c checker tool
  rmount # Remote mount utility
  nixos-generators # Generate nixos images
  patchelf
  myMpv # Wayland compatbile mpv
  imv # Wayland compatible image viewer
  evince # pdf reader
  pavucontrol # audio device switcher per programm!
  sqlite-interactive # Sqlite cli
  godot # Game engine
  mitmproxy # Great to debug https traffic

  # Network debugging
  traceroute
  tcpdump
  wireshark

  remmina # Remote Desktop application

  # Check internet speed
  #  speedtest-cli

  # Media
  wf-recorder# Screen capturing
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

# Exfat support
boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
# This value determines the NixOS release with which your system is to be
# compatible, in order to avoid breaking some software such as database
# servers. You should change this only after NixOS release notes say you
# should.
system.stateVersion = "19.03"; # Did you read the comment?

}
