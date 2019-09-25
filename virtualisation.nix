{pkgs, config, lib, ... }:

{

environment.systemPackages = with pkgs; [
  virtmanager
  virt-viewer
];

virtualisation.libvirtd.enable = true;

users.extraUsers.${config.mainUser}.extraGroups = [ "libvirtd" "vboxusers" ];


}

