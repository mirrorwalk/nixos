{
  lib,
  config,
  ...
}: {
  options.games.enable = lib.mkEnableOption "";

  config = lib.mkIf config.games.enable {
    programs.gamemode.enable = true;

    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
