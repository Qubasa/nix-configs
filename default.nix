{ config, pkgs, lib, ... }:

with lib;

let
  netname = "retiolum";
  cfg = config.networking.retiolum;
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
      # allow resolving dns
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
      '';
    };

    networking.extraHosts = builtins.readFile ../../etc.hosts;

    environment.systemPackages = [
      config.services.tinc.networks.${netname}.package
    ];

    systemd.services."tinc.${netname}-host-keys" = {
      description = "Install tinc.${netname} host keys";
      requiredBy = [ "tinc.${netname}.service" ];
      before = [ "tinc.${netname}.service" ];
      script = ''
        rm -rf /etc/tinc/${netname}/hosts
        cp -R ${../../hosts} /etc/tinc/${netname}/hosts
        chown -R tinc.${netname} /etc/tinc/${netname}/hosts
        chmod -R u+w /etc/tinc/${netname}/hosts
      '';
      # this triggers tinc restarts and it is pointless to restart tinc after the key has been created
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.services."tinc.${netname}" = {
      # Some hosts require VPN for nixos-rebuild, so we don't want to restart it on update
      reloadIfChanged = true;
      # also in https://github.com/NixOS/nixpkgs/pull/106715
      serviceConfig.ExecReload = "${config.services.tinc.networks.${netname}.package}/bin/tinc -n ${netname} reload";
    };

    networking.firewall.allowedTCPPorts = [ 655 ];
    networking.firewall.allowedUDPPorts = [ 655 ];

    systemd.network.enable = true;
    systemd.network.networks."${netname}".extraConfig = ''
      [Match]
      Name = tinc.${netname}

      [Link]
      # tested with `ping -6 turingmachine.r -s 1378`, not sure how low it must be
      MTUBytes=1377

      [Network]
      Address=${cfg.ipv4}/12
      Address=${cfg.ipv6}/16
    '';
  };
}
