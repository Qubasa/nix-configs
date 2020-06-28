{config, lib, pkgs, stdenv, ... }:

let

  # Allow callPackage to fill in the pkgs argument
  callPackage = pkgs.lib.callPackageWith (pkgs);

  ops = callPackage ./own-pkgs/ops {};

in {

  environment.systemPackages = [
    ops
  ];
}
