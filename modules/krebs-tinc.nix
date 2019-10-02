{ config, pkgs, lib, ... }:

with lib;

let
  netname = "retiolum";
  cfg = config.networking.retiolum;

retiolum = pkgs.fetchFromGitHub {
    owner = "krebs";
    repo = netname;
    rev = "e7502a74e9ddff7e9f28920f9a9034515591d0a6";
    sha256 = "0jf69vf2bs2z65nap7ll935rvszx4nsi9p79ifhb4k7z0jg9pryp";
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
      extraConfig = ''
        LocalDiscovery = yes
        AutoConnect = yes
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
  };
}

