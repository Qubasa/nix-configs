
{config, lib, pkgs, stdenv, ... }:

{

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

  # Enable nested virtualisation
  boot.extraModprobeConfig = "options kvm_amd nested=1";


  # This change gives you a hardened 5.3 kernel
  # but it has to be compiled on your machine locally
#  nixpkgs.config.packageOverrides = super: {
#    linuxPackages_latest = pkgs.unstable.pkgs.linuxPackages_5_3;
#  };

  nixpkgs.config.packageOverrides = super: {
    linuxPackages_latest = pkgs.linuxPackagesFor (pkgs.unstable.pkgs.linuxPackages_5_3.kernel.override {
      features.ia32Emulation = true;
    });
  };

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;


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
