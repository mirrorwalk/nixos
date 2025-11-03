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

  hyprpaperWrapper = inputs.wrappers.lib.wrapPackage {
    inherit pkgs;
    package = pkgs.hyprpaper;

    env = {
      XDG_CONFIG_HOME = hyprpaperConfig;
    };
  };
in {
  config = lib.mkIf config.services.hyprpaper.enable {
    services.hyprpaper = {
        package = hyprpaperWrapper;
    #   settings = {
    #     preload = toString config.styleConfig.defaultWallpaper;
    #
    #     wallpaper =
    #       map (
    #         m: "${m.name},${toString config.styleConfig.defaultWallpaper}"
    #       )
    #       (
    #         lib.filter
    #         (m: m.enabled)
    #         config.systemConfig.monitors
    #       );
    #   };
    };

    systemd.user.services.hyprpaper = {
      Install.WantedBy = ["hyprland-session.target"];
      Service.Environment = [
        # "XDG_CONFIG_HOME=${hyprpaperConfig}"
      ];
    };
  };
}
