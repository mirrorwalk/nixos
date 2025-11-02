{
  pkgs,
  lib,
  config,
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
