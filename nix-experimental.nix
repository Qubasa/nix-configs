{ lib, config, pkgs, ... }:
{



  # nix daemon optimizations
  # fetchtarball ttl set to one week
  # enabled flakes
  nix = {
    settings = {
      auto-optimise-store = true;
      sandbox = "relaxed";
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
    package = pkgs.nixUnstable;
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 40d";

    # #experimental-features = nix-command flakes
    extraOptions = ''
      keep-outputs = true       # Nice for developers
    '';
  };


}
