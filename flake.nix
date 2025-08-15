{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
        url = "github:nix-community/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, ... }@inputs: {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
              ./hosts/desktop/configuration.nix

                  stylix.nixosModules.stylix

                  home-manager.nixosModules.default

                  stylix.homeModules.stylix
          ];
      };
  };
}
