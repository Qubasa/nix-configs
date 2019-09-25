{ config, pkgs, ... }:


let

name = "hekate_ctcaer";

version = "5.0.1";
nyx_version = "0.8.1";


exploitBin = pkgs.fetchzip {
  url = "https://github.com/CTCaer/hekate/releases/download/v${version}/${name}_${version}_Nyx_${nyx_version}.zip";
  sha256 = "0q0fmf03qckibia6ckh3dk4hf5n6y6rcdycazi4czbqx5h7sxisq";
  stripRoot = false;
};


in {

# Add auto trigger udev rule to exploit switch
services.udev.extraRules = ''
ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="955/7321/102", RUN=="${pkgs.fusee-launcher}/bin/fusee-launcher ${exploitBin}/${name}_${version}.bin"
'';

environment.systemPackages = with pkgs; [
  fusee-launcher # Exploit tool for the nintendo switch
];

}
