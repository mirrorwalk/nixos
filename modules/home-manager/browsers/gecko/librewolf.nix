{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.browsers;
in {
  options.browsers.librewolf = {
    enable = lib.mkEnableOption "Enables librewolf";
    defaultBrowser = lib.mkEnableOption "Librewolf as default browser";
  };

  config = lib.mkIf cfg.librewolf.enable {
    programs.librewolf = {
      enable = true;

      policies = {
        Cookies = {
          Allow = cfg.allowedCookies;
        };
      };

      profiles.default = {
        bookmarks = cfg.gecko.bookmarks;
        # extensions = cfg.gecko.extensions;
        search = {
          force = true;
          default = cfg.search.defaultEngine;
          privateDefault = cfg.search.private.defaultEngine;
          engines = cfg.search.engines;
        };
      };
    };

    systemConfig.defaults.webBrowser = lib.mkIf cfg.librewolf.defaultBrowser {
      command = "${pkgs.librewolf}/bin/librewolf";
      desktopName = "librewolf.desktop";
    };
  };
}
