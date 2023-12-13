{ pkgs, config, lib, ... }:

{

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
  ];

  virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host = {
  #  enable = false;
  #  enableExtensionPack = true;
  #};
  virtualisation.docker.enable = true;

  users.extraUsers.${config.mainUser}.extraGroups = [ "libvirtd" "vboxusers" "docker" ];


}

