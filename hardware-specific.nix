
{config, lib, pkgs, stdenv, ... }:


let
  # https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
  # Also pinning the kernel version because unattended kernel upgrades suck
  # fast_kernel = pkgs.unstable.pkgs.linuxPackages_latest.kernel.override rec {
  #   version = "5.5.9";
  #   src = pkgs.fetchurl {
  #     url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
  #     sha256 = "0y58gkzadjwfqfry5568g4w4p2mpx2sw50sk95i07s5va1ly2dd4";
  #   };
  # };

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

  # Enable grub
  boot.loader.grub.version = 2;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  # Tried to get bios working with hdmi output
  boot.initrd.availableKernelModules = [ "xhci-hcd" "xhci-pci"  ];
  # boot.loader.grub = {
  #     gfxpayloadBios = "bios";
  #     gfxmodeBios = "auto";
  # };
  # Enable closed source firmware
  hardware.enableRedistributableFirmware = true;

  # Disable IPv6
  # boot.kernelParams = ["ipv6.disable=1"];

  # Enable nested virtualisation
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # boot.kernelPackages = pkgs.linuxPackages_hardened; #(pkgs.hardenedLinuxPackagesFor pkgs.unstable.pkgs.linuxPackages_5_5.kernel);
  boot.kernelPackages = pkgs.linuxPackages_5_4;

  ####################
  #                  #
  #     GRUB THEME   #
  #                  #
  ####################
  boot.loader.grub.extraConfig = ''
    set theme=($drive1)//themes/fallout-grub-theme/theme.txt
  '';


  boot.loader.grub.splashImage = ./resources/fallout-grub-theme/background.png;

  system.activationScripts.copyGrubTheme = ''
    mkdir -p /boot/themes
    cp -R ${./resources/fallout-grub-theme} /boot/themes
  '';

}
