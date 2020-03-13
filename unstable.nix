{ config, pkgs, lib, ... }:
{

  # This allows the global use of unstable channel through
  # pkgs.unstable.<package-name>!!
  nixpkgs.config = 
  {
      # Allow proprietary packages
      allowUnfree = true;

      # Create an alias for the unstable channel
      packageOverrides = pkgs: 
      {
          unstable = import <nixos-unstable> 
              { 
                  # pass the nixpkgs config to the unstable alias
                  # to ensure `allowUnfree = true;` is propagated:
                  config = config.nixpkgs.config; 
              };
      };
  };

}

