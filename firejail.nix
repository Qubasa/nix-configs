{ pkgs, config, lib, ... }:

let
  unstable = import <nixos-unstable> { };
in
{

  nixpkgs.config.packageOverrides = super: {
    firejail = unstable.firejail;
  };

  programs.firejail.enable = true;
  programs.firejail.wrappedBinaries = {
    thunderbird = "${pkgs.thunderbird}/bin/thunderbird";
    chromium = "${pkgs.chromium}/bin/chromium";
  };
}
