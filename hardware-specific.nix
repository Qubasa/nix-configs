
{config, lib, pkgs, stdenv, ... }:

let

  unstable = import <nixos-unstable> { };
  callPackage = pkgs.lib.callPackageWith (pkgs);
  myrtlwifi_new = callPackage ./own-pkgs/rtlwifi_new { kernel = unstable.pkgs.linux_5_3; };
in {

  # Use swap with random encryption on every reboot
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/feb82877-04";
      randomEncryption = {
        enable = true;
      };
    }
  ];


  # Set "intel" for intel cpus
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable grub
  boot.loader.grub.version = 2;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  # Enable closed source firmware
  hardware.enableRedistributableFirmware = true;

  # Enable nested virtualisation
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # Use pinned working kernel version
  boot.kernelPackages = unstable.pkgs.linuxPackages_5_3;

  # Use own realtek driver
  boot.extraModulePackages = [ myrtlwifi_new ];
}
