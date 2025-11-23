{
  lib,
  pkgs,
  config,
  ...
}: let
  hyprland = config.desktop.hyprland.enable;
  cfg = config.browsers.tor;
in{
  options.browsers.tor = {
    enable = lib.mkEnableOption "Enables tor";
    defaultBrowser = lib.mkEnableOption "tor as default browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tor-browser
    ];

    systemConfig.defaults.webBrowser = lib.mkIf cfg.defaultBrowser {
      command = "${pkgs.tor-browser}/bin/tor-browser";
      desktopName = "torbrowser.desktop";
    };

    wayland.windowManager.hyprland = lib.mkIf hyprland {
      settings = {
        windowrulev2 = [
          "float,class:^(Tor Browser)$"
          "suppressevent fullscreen maximize fullscreenoutput,class:(Tor Browser)"
        ];
      };
    };
  };
}
