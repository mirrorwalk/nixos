{
  lib,
  config,
  pkgs,
  ...
}: {
  options.games.enable = lib.mkEnableOption "enable game specific options";

  config = lib.mkIf config.games.enable {
    programs = {
      gamemode.enable = true;

      steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;

        # extraPackages = with pkgs; [
        #   protonup-ng
        #   wine
        # ];
      };

      gamescope.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wine
    ];
  };
}
