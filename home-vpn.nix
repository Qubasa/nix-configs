{ config, pkgs, lib, ... }: let

  interface_name = "home-ovpn";
 vpn_nameserver = "192.168.1.1";
 # vpn_nameserver = "1.1.1.1";
  pwd_file = "${config.secrets}/vpn/home-vpn/home-vpn.pwd";

  tls-auth-cert = "${config.secrets}/vpn/home-vpn/home-vpn.tls";
  ca-cert = "${config.secrets}/vpn/home-vpn/home-vpn.p12";

  home-vpn = pkgs.writeScriptBin "home-vpn" ''
    #!/bin/sh

    if [ "$(systemctl is-active 'openvpn-${interface_name}')" == "active" ]; then
      echo "Stopping openvpn-${interface_name}"
      systemctl stop "openvpn-${interface_name}"
    else
      echo "Starting openvpn-${interface_name}"
      systemctl start "openvpn-${interface_name}"
    fi'';

in {

  services.openvpn.servers."${interface_name}" = {

    autoStart = false;
    config = ''
      # Options that should always be set
      dev ${interface_name}
      dev-type tun
      persist-key
      persist-remote-ip
      float
      keepalive 15 60
      # Do NOT use <persist-tun> as this disables running of
      # up/down scripts on reconnect

      cipher AES-128-CBC
      ncp-ciphers AES-128-GCM
      auth SHA256
      tls-client
      client
      resolv-retry infinite
      remote ovpn.gchq.icu 1195 udp
      verify-x509-name "pfsense.intern.gchq.icu" name
      auth-user-pass
      remote-cert-tls server

      dhcp-option DNS ${vpn_nameserver}
      auth-user-pass ${pwd_file}

      pkcs12 ${ca-cert}
      tls-auth ${tls-auth-cert} 1
  '';

    updateResolvConf = true;
  };

  systemd.services."openvpn-${interface_name}" = {
    serviceConfig = {
      KillSignal = "SIGINT";
      Type = lib.mkForce "simple";
    };
  };


  environment.systemPackages = with pkgs; [
    home-vpn
  ];

}

