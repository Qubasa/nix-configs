{config, lib, pkgs, stdenv, ... }:

let

  # Allow callPackage to fill in the pkgs argument
  callPackage = pkgs.lib.callPackageWith (pkgs);

  rmount = callPackage ./own-pkgs/rmount/default.nix {  };
  hopper = callPackage ./own-pkgs/hopper/default.nix {  };
in {


  environment.systemPackages = with pkgs; [
    # deezer-downloader
    rmount
    hopper

  ];
}
