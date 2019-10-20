{ config, pkgs, lib, ... }:

{

networking.wireless.iwd.enable = true;

# networking.networkmanager.enable = true;

networking.dhcpcd.denyInterfaces = [ "macvtap*" ];

# Disable so no IPv6 leak on VPN usage
networking.enableIPv6 = false;

# Allow incomming connections on port 1234 for netcat and sharing stuff
networking.firewall.allowedTCPPorts = [ 1234 ];

# Hostname
networking.hostName = "qubasa";

# networking.networkmanager.insertNameservers = [ "1.1.1.1" ];

}
