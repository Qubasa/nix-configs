{config, lib, pkgs, stdenv, ... }:

let

  # Allow callPackage to fill in the pkgs argument
  callPackage = pkgs.lib.callPackageWith (pkgs);

  rmount = callPackage ./own-pkgs/rmount/default.nix {  };
  hopper = callPackage ./own-pkgs/hopper/default.nix {  };
  pyocclient = callPackage ./own-pkgs/pyocclient {};
  deezer-downloader = callPackage ./own-pkgs/deezer-downloader { inherit pyocclient;  };
  wl-clipboard = callPackage ./own-pkgs/wl-clipboard {};
in {


  environment.systemPackages = with pkgs; [
    # deezer-downloader
    wl-clipboard
    rmount
    hopper

  ];
}
