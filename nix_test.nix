{ config, pkgs, ... }:
let
  nix-test = pkgs.writeScriptBin "nix-test" ''
    #!/bin/sh

     VM=$(/run/current-system/sw/bin/nixos-rebuild --fast build-vm 2>&1 | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gawk}/bin/awk '{ print $10 }')
     echo "$VM"
     # Use 4G RAM and 8 cores and 256M video RAM
     "$VM" -m 4G -smp 8 -device VGA,vgamem_mb=256  -object input-linux,id=kbd1,evdev=/dev/myCherry,grab_all=on,repeat=on -device virtio-keyboard-pci "$@"
  '';

in
{

  # Find your keyboard device info with
  # udevadm info --attribute-walk /dev/input/by-id/usb-Cherry_USB_keyboard-event-kbd
  # For explanation see: man udev
  # To trigger new rule: udevadm control --reload-rules && udevadm trigger
  services.udev.extraRules = ''
  SUBSYSTEM=="input", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="b090", SYMLINK+="myCherry"
   SUBSYSTEMS=="input", ATTRS{idVendor}=="0002", ATTRS{idProduct}=="0007", SYMLINK+="myTouchy"
  '';

  environment.systemPackages = with pkgs; [
    nix-test
  ];
}
