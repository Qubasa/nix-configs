{ pkgs, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs.unstable.pkgs);
in 
{
  nixpkgs.config.packageOverrides = super: {
    sway-unwrapped = callPackage ./own-pkgs/sway {};
  };

}
