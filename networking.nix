{ config, pkgs, lib, ... }:
{
  # Hostname
  networking.hostName = "qubasa-desktop";

  # Needed for same origin policy in web dev & debugging
  networking.extraHosts = "127.0.0.1 localhost dev.localhost";

  # Local blacklist
  networking.hosts = {
    #"127.0.0.1" = [ "9gag.com" ];
  };


  networking.networkmanager = {
    insertNameservers = [ "1.1.1.1" "1.1.1.2" ];
    dns = lib.mkDefault "systemd-resolved";
  };

  networking.firewall = {
    allowedTCPPorts = [ 1234  ];
    allowedUDPPorts = [ 1234 ];
  };
}
