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

in
  {

    environment.systemPackages = with pkgs; [
      gnome3.dconf
      gnome3.networkmanagerapplet
    ];

  systemd.user.services.dconf-settings = {
    description = "Set dconf settings";
    partOf = [ "sway-session.target" ];
    wantedBy = [ "sway-session.target" ];
    after = ["sway-session.target"];
    wants = ["sway-session.target"];
    script = ''
      #!/bin/sh
      set -xe
      ${pkgs.libudev}/bin/systemctl --user import-environment
      ${pkgs.gnome3.dconf}/bin/dconf load /org/virt-manager/virt-manager/ < ${dconf-virt-manager-stats}
      ${pkgs.gnome3.dconf}/bin/dconf load /org/virt-manager/virt-manager/ < ${dconf-virt-manager-vmlist-fields}
    '';
  };

  }

