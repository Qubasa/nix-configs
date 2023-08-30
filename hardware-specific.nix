{ config, lib, pkgs, stdenv, ... }:

{

  # Use swap with random encryption on every reboot
  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
      randomEncryption = {
        enable = true;
      };
    }
  ];

  # Enable grub
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  # Tried to get initrd working with hdmi output
  boot.initrd.availableKernelModules = [ "xhci-hcd" "xhci-pci" ];

  # Enable closed source firmware
  hardware.enableRedistributableFirmware = true;

  # Disable IPv6
  #boot.kernelParams = ["ipv6.disable=1"];

  # Enable nested virtualisation
  boot.extraModprobeConfig = ''
  options kvm_amd nested=1
  options msr allow_writes=1
  '';


  security.wrappers.turbostat = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_rawio,cap_sys_nice=ep";
    source = "${config.boot.kernelPackages.turbostat}/bin/turbostat";
  };

  # latest
#  boot.kernelPackages = pkgs.linuxPackages_hardened;

  environment.systemPackages =
  with pkgs; [
    # Logitech specific
    solaar # logitech device support
    # Opengl debugging
    clinfo
    glxinfo
    vulkan-tools
    config.boot.kernelPackages.turbostat
  ];

  services.udev.packages = with pkgs; [
    solaar # logitech device support
    logitech-udev-rules
  ];

  # xilinx papilio pro fpga rule
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0666", GROUP="plugdev"
  '';

  # Enable opengl
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  environment.variables.VK_ICD_FILENAMES =
  "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  services.xserver.videoDrivers = [ "amdgpu" ];

  ####################
  #                  #
  #     GRUB THEME   #
  #                  #
  ####################
 # boot.loader.grub.extraConfig = ''
 #   set theme=($drive1)//themes/fallout-grub-theme/theme.txt
 # '';

 # boot.loader.grub.splashImage = ./resources/fallout-grub-theme/background.png;

  #boot.loader.grub.extraPrepareConfig = ''
  # # extra prepare config
  # insmod all_video
  # insmod usb
  # insmod usb_keyboard
  # insmod uhci
  # insmod pci
  #'';

#  system.activationScripts.copyGrubTheme = ''
#    mkdir -p /boot/themes
#    cp -R ${./resources/fallout-grub-theme} /boot/themes/fallout-grub-theme
#  '';

}
