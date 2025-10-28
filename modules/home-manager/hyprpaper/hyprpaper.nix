{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprpaper-random.nix
  ];
  options.hyprpaper = {
      enable = lib.mkEnableOption "Enables hyprpaper";
    defaultWallpaper = lib.mkOption {
      default = "/home/brog/Pictures/Wallpapers/thumb-1920-1345286.png";
      type = lib.types.str;
      description = "The default wallpaper to load";
    };
    monitor = lib.mkOption {
        default = "DP-1";
    };
  };
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = config.hyprpaper.defaultWallpaper;
        wallpaper = "${config.hyprpaper.monitor},${config.hyprpaper.defaultWallpaper}";
      };
    };
  };
}
