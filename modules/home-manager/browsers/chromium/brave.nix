{
  pkgs,
  config,
  lib,
  ...
}: {
  options.browsers.brave = {
    enable = lib.mkEnableOption "Enable brave browser";
    defaultBrowser = lib.mkEnableOption "Brave as default browser";
  };

  config = lib.mkIf config.browsers.brave.enable {
    home.packages = [
      pkgs.brave
    ];

    systemConfig.defaults.webBrowser = lib.mkIf config.browsers.brave.defaultBrowser {
      command = "${pkgs.brave}/bin/brave";
      desktopName = "brave-desktop.desktop";
    };
  };
}
