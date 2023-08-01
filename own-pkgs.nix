{ config, lib, pkgs, stdenv, buildPythonPackage, fetchPypi, ... }:

let

  # Allow callPackage to fill in the pkgs argument
  callPackage = pkgs.lib.callPackageWith (pkgs);

  talon = callPackage ./ownpkgs/talon { };
  parsec = callPackage ./ownpkgs/parsec { };
  vuescan = callPackage ./ownpkgs/vuescan {};
in
{


  #services.udev.packages = [ talon ];
  environment.systemPackages = [
   # talon
   # vuescan
  ];
}
