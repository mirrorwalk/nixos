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

    browsers.default.browser = {
      enable = true;
      desktopName =
        lib.mkIf config.browsers.mullvad.defaultBrowser "mullvad-browser.desktop";
    };
  };
}
