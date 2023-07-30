{ config, pkgs, ... }:


let



in {
  environment.systemPackages = [  ];

  # Enable nix ld
  programs.nix-ld.enable = true;

  services.envfs.enable = true;

  environment.variables = with pkgs;  {

     #Can create bugs if the calling process uses a different glibc then this fuse does
     #However this is needed to run AppImages as they do not have a reference to a link loader in their binary
     #Thus not triggering nix-ld
     LD_LIBRARY_PATH =  lib.mkForce ( (lib.makeLibraryPath [ fuse3 fuse ]) + ":" + config.environment.sessionVariables.LD_LIBRARY_PATH);
  };

}
