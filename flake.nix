{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  inputs.chrome-pwa.url = "github:luis-hebendanz/nixos-chrome-pwa";
  inputs.nur.url = github:nix-community/NUR;

  # this line assume that you also have nixpkgs as an input
  inputs.luispkgs.url = "github:Luis-Hebendanz/nixpkgs/luispkgs";
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.master.url = "github:NixOS/nixpkgs/master";
  inputs.clan-core = {
    url = "git+https://git.clan.lol/clan/clan-core";
 #   inputs.nixpkgs.follows = "nixpkgs";
  };


  inputs.retiolum = {
    url = "github:Mic92/retiolum";
    flake = false;
  };
  # Makes nix rebuild unbearibly slow for some reason
  # inputs.dwarffs.url = "github:edolstra/dwarffs";
  # inputs.nix.url = "github:NixOS/nix";

  # inputs.nixpack.url  ="github:dguibert/nixpack/dg/flake";



  outputs = { self, clan-core, nixpkgs, retiolum, nur, luispkgs, unstable, master, chrome-pwa }: 
  let
    clan = clan-core.lib.buildClan {
        clanName = "qubasaClan";
        directory = self;
        # replace 'qubasa-desktop' with your hostname here.
        machines = {
          qubasa-desktop = {
            #nixpkgs.pkgs = nixpkgs.legacyPackages.x86_64-linux;
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./configuration.nix
              chrome-pwa.nixosModule

              { nixpkgs.overlays = [ nur.overlay ]; }

              ({ ... }: {
                # Set nix-channel to nix flake registry
                nix.nixPath = let path = toString ./.; in [ "repl=${path}/repl.nix" "nixpkgs=${self.inputs.nixpkgs}" ];
                nix.registry = {
                  self.flake = self;
                  nixpkgs = {
                    from = { id = "nixpkgs"; type = "indirect"; };
                    flake = nixpkgs;
                  };
                };

                nixpkgs.config = {
                  allowUnfree = true;
                  packageOverrides = pkgs:
                    {

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
      };
  in {
    inherit (clan) nixosConfigurations clanInternals; 
  };
}

