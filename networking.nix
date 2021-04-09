{ config, pkgs, lib, ... }:

{

# networking.wireless.iwd.enable = true;

networking.networkmanager.enable = true;

networking.dhcpcd.denyInterfaces = [ "macvtap*" ];

# Disable so no IPv6 leak on VPN usage
networking.enableIPv6 = true;

# Allow incomming connections on port 1234 for netcat and sharing stuff
networking.firewall.allowedTCPPorts = [ 1234 ];

# Hostname
networking.hostName = "qubasa";

# Needed for same origin policy in web dev & debugging
networking.extraHosts = "127.0.0.1 localhost dev.localhost";

networking.networkmanager = {
  dns = "systemd-resolved";
};
services.resolved = {
  enable = true;
  extraConfig = ''
    # DNSOverTLS=true
    DNS=95.216.223.74#qube.email 2a01:4f9:c010:51cd::2#qube.email
    #DNSSEC=allow-downgrade
  # '';
  # fallbackDns = [  "95.216.223.74" "2a01:4f9:c010:51cd::2" ];
};
networking.networkmanager.insertNameservers = [ "95.216.223.74" "2a01:4f9:c010:51cd::2" ];
# networking.networkmanager.insertNameservers = ["1.1.1.1" "1.0.0.1" ];

}
