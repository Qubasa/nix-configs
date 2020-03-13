{ config, pkgs, lib, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchGit {
      url = "https://github.com/nix-community/NUR.git";
      rev = "aef8b9c4f41b5ce408f739679e2e12dcdbc7829b";
    })
    {
      inherit pkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    nur.repos.mic92.nixos-shell
  ];
}
