
{
  lib,
  pkgs,
  config,
  ...
}: {
  options.browsers.tor = {
    enable = lib.mkEnableOption "Enables tor";
    defaultBrowser = lib.mkEnableOption "tor as default browser";
  };

  config = lib.mkIf config.browsers.tor.enable {
      home.packages = [
        pkgs.tor-browser
      ];

    systemConfig.default.webBrowser = lib.mkIf config.browsers.tor.defaultBrowser {
      command = "${pkgs.tor-browser}/bin/tor-browser";
      desktopName = "torbrowser.desktop";
    };
  };
}
