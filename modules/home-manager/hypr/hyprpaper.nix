{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  hyprpaperConfig = pkgs.writeTextDir "hypr/hyprpaper.conf" ''
    preload=${toString config.styleConfig.defaultWallpaper}
    ${
      lib.concatMapStringsSep "\n" (
        m: "wallpaper=${m.name},${toString config.styleConfig.defaultWallpaper}"
      )
      (
        lib.filter
        (m: m.enabled)
        config.systemConfig.monitors
      )
    }
  '';
in {
  config = lib.mkIf config.services.hyprpaper.enable {
    systemd.user.services.hyprpaper = {
      Install.WantedBy = ["hyprland-session.target"];
      Service.Environment = [
        "XDG_CONFIG_HOME=${hyprpaperConfig}"
      ];
    };
  };
}
