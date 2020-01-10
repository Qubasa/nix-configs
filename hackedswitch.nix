{ config, pkgs, ... }:


let

name = "hekate_ctcaer";

version = "5.1.1";
nyx_version = "0.8.4";


exploitBin = pkgs.fetchzip {
  url = "https://github.com/CTCaer/hekate/releases/download/v${version}/${name}_${version}_Nyx_${nyx_version}.zip";
  sha256 = "0z7ccpj5agiff4np9silynmbm13n883f2bw9ckbl0a7sfv6ww9l5";
  stripRoot = false;
};


in {

# Add auto trigger udev rule to exploit switch
services.udev.extraRules = ''
ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="955/7321/102", RUN+="${pkgs.fusee-launcher}/bin/fusee-launcher ${exploitBin}/${name}_${version}.bin"
'';

environment.systemPackages = with pkgs; [
  fusee-launcher # Exploit tool for the nintendo switch
];

}
