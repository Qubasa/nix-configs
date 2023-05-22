{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.chrome-pwa.url = "github:luis-hebendanz/nixos-chrome-pwa";
  inputs.nur.url = github:nix-community/NUR;
  inputs.envfs.url = "github:Mic92/envfs";
  inputs.envfs.inputs.nixpkgs.follows = "nixpkgs";
  # this line assume that you also have nixpkgs as an input
  inputs.luispkgs.url = "github:Luis-Hebendanz/nixpkgs/luispkgs";
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.master.url = "github:NixOS/nixpkgs/master";


  inputs.retiolum = {
    url = "github:Mic92/retiolum";
    flake = false;
  };
  # Makes nix rebuild unbearibly slow for some reason
  # inputs.dwarffs.url = "github:edolstra/dwarffs";
  # inputs.nix.url = "github:NixOS/nix";

 # inputs.nixpack.url  ="github:dguibert/nixpack/dg/flake";


  outputs = { self, nixpkgs, retiolum, nur, envfs, luispkgs, unstable, master, chrome-pwa }: {
    # replace 'qubasa-desktop' with your hostname here.
    nixosConfigurations.qubasa-desktop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        chrome-pwa.nixosModule
        envfs.nixosModules.envfs

        { nixpkgs.overlays = [ nur.overlay ]; }

        ({ ... }: {
          # Set nix-channel to nix flake registry
          nix.nixPath = let path = toString ./.; in [ "repl=${path}/repl.nix" "nixpkgs=${self.inputs.nixpkgs}" ];

          nixpkgs.config = {
            allowUnfree = true;
            packageOverrides = pkgs:
            {
           #   nixpack = nixpack.packages.x86_64-linux;
              envfs = envfs.packages.x86_64-linux.envfs;
              retiolum = retiolum;
              luis = import luispkgs
              {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                };
              };
              unstable = import unstable
              {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                };
              };
              master = import master
              {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                };
              };
            };
          };
        })
      ];
    };
  };
}

