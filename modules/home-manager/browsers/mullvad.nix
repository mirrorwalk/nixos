{
  pkgs,
  lib,
  config,
  ...
}: {
  options.browsers.mullvad = {
    enable = lib.mkEnableOption "Enable mullvad browser";
    defaultBrowser = lib.mkEnableOption "Mullvad as default browser";
  };

  config = lib.mkIf config.browsers.mullvad.enable {
    home.packages = [
      pkgs.mullvad-browser
    ];

    systemConfig.default.webBrowser = lib.mkIf config.browsers.mullvad.defaultBrowser {
      desktopName = "mullvad-browser.desktop";
      command = "${pkgs.mullvad-browser}/bin/mullvad-browser";
    };
  };
}
