{
  pkgs,
  lib,
  config,
  ...
}: let
  hyprland = config.desktop.hyprland.enable;
  cfg = config.browsers.mullvad;
in {
  options.browsers.mullvad = {
    enable = lib.mkEnableOption "Enable mullvad browser";
    defaultBrowser = lib.mkEnableOption "Mullvad as default browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mullvad-browser
    ];

    systemConfig.defaults.webBrowser = lib.mkIf cfg.defaultBrowser {
      desktopName = "mullvad-browser.desktop";
      command = "${pkgs.mullvad-browser}/bin/mullvad-browser";
    };

    wayland.windowManager.hyprland = lib.mkIf hyprland {
      settings = {
        windowrulev2 = [
          "float,class:(Mullvad Browser)"
          "suppressevent fullscreen maximize fullscreenoutput,class:(Mullvad Browser)"
        ];
      };
    };
  };
}
