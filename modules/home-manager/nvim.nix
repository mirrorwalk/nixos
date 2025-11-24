{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
  ];

  config = lib.mkIf config.programs.neovim.enable {
    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs;[
        gcc
        gnumake
        git
        cargo
        nodejs
      ];
    };

    home.sessionVariables = {
      VISUAL = "nvim";
    };

    home.packages = [
      pkgs.nixd
    ];
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
