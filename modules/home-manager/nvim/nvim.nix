{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.nvimFZF.default
  ];

  options.nvim.enable = lib.mkEnableOption "Enable nvim";

  config = lib.mkIf config.nvim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = [
        pkgs.gcc
        pkgs.gnumake
        pkgs.git
        pkgs.cargo
        pkgs.nodejs
      ];
    };

    home.sessionVariables = {
      VISUAL = "nvim";
    };
  };
}
