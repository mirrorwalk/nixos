{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.services.hyprpaper.enable {
    services.hyprpaper = {
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

    systemd.user.services.hyprpaper = {
        Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
