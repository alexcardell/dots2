{
  description = "NixOS system configuration (alexcardell)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nur,
    home-manager,
    darwin,
    # neovim-nightly-overlay,
    ...
  }:
    let
      darwinConfiguration = { pkgs, ... }: {
        nix.package = pkgs.nixVersions.stable;
        nix.extraOptions = ''
          experimental-features = nix-command flakes
        '';
        services.nix-daemon.enable = true;
      };

      overlay-unstable = system: final: prev: {
        # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      sharedOverlays = system: [
        (overlay-unstable system)
        nur.overlays.default
        # neovim-nightly-overlay.overlays.default
      ];

      nixosConfiguration = hostname:
        let
          system = "x86_64-linux";
          overlays = ({ ... }: {
            nixpkgs.overlays = sharedOverlays system;
          });
          os-configuration = ./nixos/systems/linux/configuration.nix;
          os-home = ./nixos/systems/linux/home/default.nix;
          host-configuration = (./nixos/hosts + "/${hostname}" + /configuration.nix);
          host-home = (./nixos/hosts + "/${hostname}" + /home/default.nix);
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          # allow `nixpkgs-unstable` as an argument to a module
          # specialArgs =  nixpkgs-unstable;

          modules = [
            overlays
            os-configuration
            host-configuration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = {
                imports = [
                  os-home
                  host-home
                  ./nixos/home/default.nix
                ];
              };
            }
          ];
        };

    in
    {
      nixosConfigurations = {
        nixbox = nixosConfiguration "nixbox";
        nixpad = nixosConfiguration "nixpad";
      };

      darwinConfigurations = {
        "RJ4QHFPQRX" =
          let
            system = "aarch64-darwin";
            overlays = ({ ... }: {
              nixpkgs.overlays = sharedOverlays system;
            });
          in
          darwin.lib.darwinSystem {
            inherit system;

            modules = [
              overlays
              darwinConfiguration
              ./nixos/systems/darwin/configuration.nix
              ./nixos/hosts/darwin/configuration.nix
              home-manager.darwinModule
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  users.alexcard = {
                    imports = [
                      ./nixos/systems/darwin/home/default.nix
                      ./nixos/hosts/darwin/home/default.nix
                      ./nixos/home/default.nix
                    ];
                  };
                };
              }
            ];
          };
      };
    };
}
