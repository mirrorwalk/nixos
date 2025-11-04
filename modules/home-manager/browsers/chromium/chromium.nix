{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.browsers.chromium;
in {
  options.browsers.chromium = {
    enable = lib.mkEnableOption "Enable brave browser";
    defaultBrowser = lib.mkEnableOption "Brave as default browser";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
    };

    systemConfig.defaults.webBrowser = lib.mkIf cfg.defaultBrowser {
      command = "${pkgs.chromium}/bin/chromium";
      desktopName = "chromium-browser.desktop";
    };
  };
}
