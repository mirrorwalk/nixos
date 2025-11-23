{
  pkgs,
  lib,
  config,
  ...
}: {
  options.games.enable = lib.mkEnableOption "enable game specific options";

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      # lutris
      protonup-ng
    ];

    programs.lutris = {
      enable = true;
      extraPackages = with pkgs; [
        gamemode
        gamescope
      ];
    };
  };
}
