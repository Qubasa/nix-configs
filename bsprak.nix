{ config, pkgs, lib, ... }:

let
 lan_interface_name = "enp2s0";
in {

  networking.dhcpcd.denyInterfaces = [ lan_interface_name ];

  # Enables the tftp server
  services.tftpd = {
    enable = true;
    path = "/tmp/tftp";
  };

  # Disables tftpd on machine bootup
  systemd.services."xinetd" = {
    wantedBy = lib.mkForce [];
  };

  # Allows port 69 and port 67 to be reachable
  networking.firewall.allowedUDPPorts = [ 69 67 ];

  # Disable dhcpcd on machine bootup
  systemd.services."dhcpd4" = {
    wantedBy = lib.mkForce [];
  };

 # Configures the dhcp server
 services.dhcpd4 = {
   enable = true;
   interfaces = [ lan_interface_name ];
   extraConfig = ''
 subnet 192.168.178.0 netmask 255.255.255.0 {
     option domain-name-servers 1.1.1.1;
     option subnet-mask 255.255.255.0;
     option routers 192.168.178.43;
     range 192.168.178.50 192.168.178.254;
 }
     '';
 };

 # Shell script dependencies
 environment.systemPackages = with pkgs; [
    picocom
 ];
}
