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
  };

  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = toString config.styleConfig.defaultWallpaper;
        wallpaper =
          map (
            m: "${m.name},${toString config.styleConfig.defaultWallpaper}"
          )
          (
            lib.filter
            (m: m.enabled)
            config.systemConfig.monitors
          );
      };
    };
  };
}
