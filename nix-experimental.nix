{ lib, config, pkgs, ... }:
{

  # nix daemon optimizations
  # fetchtarball ttl set to one week
  # enabled flakes
  nix = {
    settings = {
      auto-optimise-store = true;
      auto-allocate-uids = true;
      system-features = lib.mkDefault [ "uid-range" ];
      experimental-features = [
        # for container in builds support
        "auto-allocate-uids"
        "flakes"
        "nix-command"
        "cgroups"
        # run builds with network access but without fixed-output checksum
        "impure-derivations"
      ];
    };
    package = pkgs.nixUnstable;
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 15d";

    # #experimental-features = nix-command flakes
    extraOptions = ''
      keep-outputs = true       # Nice for developers
      tarball-ttl = 4294967295
    '';
  };


}
