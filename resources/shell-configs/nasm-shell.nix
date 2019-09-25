# fhsUser.nix
{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "example-env";
  targetPkgs = pkgs: with pkgs; [
    coreutils
  ];
  multiPkgs = pkgs: with pkgs; [
    zlib
    gcc
    nasm
    gdb
    binutils
    gnumake
    man-pages
  ];
  runScript = "bash";
}).env

