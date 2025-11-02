{
  pkgs,
  lib,
  config,
  ...
}: {
  options.games.enable = lib.mkEnableOption "";

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      lutris
      protonup-ng
    ];
  };
}
