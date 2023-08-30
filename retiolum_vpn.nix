{ config, pkgs, ... }:

 {
  imports =
  [ # Include the results of the hardware scan.
    ./retiolum_mic.nix
  ];

  networking.retiolum.ipv6 = "42:0:3c46:123e:bbea:3529:db39:6764";
  networking.retiolum.ipv4 = "10.243.29.175";
  networking.retiolum.nodename = "qubasa";

   programs.ssh.extraConfig = ''
    Host *.dse.in.tum.de !login.dse.in.tum.de !sarah.dse.in.tum.de !donna.dse.in.tum.de
      ProxyJump tunnel@login.dse.in.tum.de
  '';

  systemd.services.nix-daemon.environment.SSHAUTHSOCK = "/run/user/1000/gnupg/S.gpg-agent";
  # fileSystems."/mnt/prism" = {
  #   device = "//prism.r/public";
  #   fsType = "cifs";
  #   options = [
  #     "guest"
  #     "nofail"
  #     "noauto"
  #     "ro"
  #     "x-systemd.automount"
  #     "x-systemd.device-timeout=1"
  #     "x-systemd.idle-timeout=1min"
  #   ];
  # };
}