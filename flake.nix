{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    privateConfig = {
      url = "git+ssh://git@github.com/mirrorwalk/nixos-private.git";
      # url = "path:/home/brog/.config/nixos-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmuxWorkspace = {
        url = "github:mirrorwalk/tmux-workspace";
        # url = "path:/home/brog/.local/bin/tmux-workspace";
    };

    nvimFZF = {
        url = "github:mirrorwalk/nvim-fzf";
        # url = "path:/home/brog/.local/bin/nvim-fzf";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    privateConfig,
    tmuxWorkspace,
    nvimFZF,
    ...
  } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
            ];
          }
        ];
      };
      zentop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/zentop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
            ];
          }
        ];
      };
    };
  };
}
