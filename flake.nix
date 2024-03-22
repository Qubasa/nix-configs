{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.chrome-pwa = {
    url = "github:luis-hebendanz/nixos-chrome-pwa";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.clan-core = {
    url = "git+https://git.clan.lol/clan/clan-core";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.stable.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = inputs @ { self, nur, stable, chrome-pwa, nixpkgs, clan-core, ... }: 
  let
    clan = clan-core.lib.buildClan {
        specialArgs = {
            inherit stable;
        };
        clanName = "qubasaClan";
        directory = self;
        # replace 'qubasa-desktop' with your hostname here.
        machines = {
          qubasa-desktop = {
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
                    permittedInsecurePackages = [
                    ];
                    allowUnfree = true;
                    packageOverrides = pkgs:
                    {
                      stable = import stable
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

