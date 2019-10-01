{config, pkgs, lib, ...}:

let

dconf-virt-manager-vmlist-fields = pkgs.writeText "dconf-virt-manager-vmlist-fields.conf" ''
    [vmlist-fields]
    cpu-usage=true
    host-cpu-usage=false
    memory-usage=true
    network-traffic=true
    disk-usage=true
'';

  dconf-virt-manager-stats = pkgs.writeText "dconf-virt-manager-stats.conf" ''
    [stats]
    enable-memory-poll=true
    enable-net-poll=true
    update-interval=5
    enable-disk-poll=true
'';

  dconf_script = pkgs.writeScript "dconf-script.sh" ''
    #!/bin/sh
    set -xe
    ${pkgs.libudev}/bin/systemctl --user import-environment
    ${pkgs.gnome3.dconf}/bin/dconf load /org/virt-manager/virt-manager/ < ${dconf-virt-manager-stats}
    ${pkgs.gnome3.dconf}/bin/dconf load /org/virt-manager/virt-manager/ < ${dconf-virt-manager-vmlist-fields}
    '';
in
  {

    environment.systemPackages = with pkgs; [
      gnome3.dconf
    ];

  systemd.user.services.dconf-settings = {
    description = "Set dconf settings";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${dconf_script}";
    };
  };

  }

