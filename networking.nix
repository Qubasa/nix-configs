{ config, pkgs, lib, ... }:

{

# networking.wireless.iwd.enable = true;

networking.networkmanager.enable = true;

networking.dhcpcd.denyInterfaces = [ "macvtap*" ];

# Disable so no IPv6 leak on VPN usage
networking.enableIPv6 = false;

# Allow incomming connections on port 1234 for netcat and sharing stuff
networking.firewall.allowedTCPPorts = [ 1234 ];

# Hostname
networking.hostName = "qubasa";

# Needed for same origin policy in web dev & debugging
networking.extraHosts = "127.0.0.1 localhost dev.localhost";

networking.networkmanager.dns = "systemd-resolved";
networking.networkmanager.insertNameservers = [ "95.216.223.74" ];

}
