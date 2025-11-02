{
  lib,
  pkgs,
  config,
  ...
}: {
  options.browsers.librewolf = {
    enable = lib.mkEnableOption "Enables librewolf";
    defaultBrowser = lib.mkEnableOption "Librewolf as default browser";
  };

  config = lib.mkIf config.browsers.librewolf.enable {
    programs.librewolf = {
      enable = true;
      profiles.default = {
        bookmarks = config.browsers.firefox.bookmarks;
        extensions = config.browsers.firefox.extensions;
        search = {
          force = true;
          default = config.browsers.search.defaultEngine;
          privateDefault = config.browsers.search.private.defaultEngine;
          engines = config.browsers.search.engines;
        };
      };
    };

    systemConfig.default.webBrowser = lib.mkIf config.browsers.librewolf.defaultBrowser {
      command = "${pkgs.librewolf}/bin/librewolf";
      desktopName = "librewolf.desktop";
    };
  };
}
