{ config, pkgs, lib, ... }:

with lib;

let
  netname = "retiolum";
  cfg = config.networking.retiolum;

retiolum = pkgs.fetchFromGitHub {
    owner = "krebs";
    repo = netname;
    rev = "3fc3147ef4c644b4008f1425fae701f2d371db52";
    sha256 = "sha256-xRPspeeILgSGC0XytbqpIisrXWwHIIoMS15bOxvQCO4=";
  };


  krebs-tinc = pkgs.writeScriptBin "krebs-tinc" ''
    #!/bin/sh

    if [ "$(systemctl is-active 'tinc.${netname}')" == "active" ]; then
      echo "Stopping tinc.${netname}"
      systemctl stop "tinc.${netname}"
    else
      echo "Starting tinc.${netname}"
      systemctl start "tinc.${netname}"
    fi'';

in {
 options = {
    networking.retiolum.ipv4 = mkOption {
      type = types.str;
      description = ''
        own ipv4 address
      '';
    };
    networking.retiolum.ipv6 = mkOption {
      type = types.str;
      description = ''
        own ipv6 address
      '';
    };

    networking.retiolum.nodename = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = ''
        tinc network name
      '';
    };
  };

  config = {

    services.tinc.networks.${netname} = {
      name = cfg.nodename;
      chroot = false;
      extraConfig = ''
        LocalDiscovery = yes
        
        ConnectTo = gum
        ConnectTo = ni
        ConnectTo = prism
        ConnectTo = eve
        ConnectTo = eva
        ConnectTo = hydrogen
        AutoConnect = yes

        PrivateKeyFile = /etc/tinc/retiolum/rsa_key.priv
      '';
    };

    systemd.services."tinc.${netname}" = {
      preStart = ''
        cp -R ${retiolum}/hosts /etc/tinc/retiolum/ || true
      '';

      after = lib.mkForce [];
      wantedBy = lib.mkForce [];
      restartTriggers = lib.mkForce [];
    };

    networking.extraHosts = builtins.readFile (toString "${retiolum}/etc.hosts");

    environment.systemPackages = [ krebs-tinc config.services.tinc.networks.${netname}.package ];

    networking.firewall.allowedTCPPorts = [ 655 ];
    networking.firewall.allowedUDPPorts = [ 655 ];

    networking.interfaces.retiolum = {
      name = "tinc.${netname}";
      ipv4.addresses = [ { address="${cfg.ipv4}"; prefixLength = 12; } ];
      virtual = true;
      useDHCP = false;
      virtualType = "tun";
    };

    systemd.network.enable = true;
    systemd.network.networks."${netname}".extraConfig = ''
      [Match]
      Name = tinc.${netname}
      [Link]
      # tested with `ping -6 turingmachine.r -s 1378`, not sure how low it must be
      MTUBytes=1377
      [Network]
      Address=${cfg.ipv4}/12
    '';
  };
}

