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


  #networking.networkmanager.insertNameservers = [ "95.216.223.74" "2a01:4f9:c010:51cd::2" ];
  #networking.networkmanager.insertNameservers = [ "127.0.0.1" "::" ];

  networking.firewall.allowedUDPPorts = [ 1234 ];

}
