{
  lib,
  pkgs,
  config,
  ...
}: let
  cfgBrowsers = config.browsers;
  cfg = cfgBrowsers.librewolf;
  cfgS = cfg.search;
in {
  options.browsers.librewolf = {
    enable = lib.mkEnableOption "Enables librewolf";
    defaultBrowser = lib.mkEnableOption "Librewolf as default browser";

    search = {
      defaultEngine = lib.mkOption {
        description = "default search engine";
        default = cfgBrowsers.search.defaultEngine;
        type = lib.types.nonEmptyStr;
      };
      private.defaultEngine = lib.mkOption {
        description = "default private search engine";
        default = cfgBrowsers.search.private.defaultEngine;
        type = lib.types.nonEmptyStr;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      policies = {
        Cookies = {
          Allow = cfgBrowsers.allowedCookies;
        };
      };

      profiles.default = {
        bookmarks = cfgBrowsers.gecko.bookmarks;
        extensions = cfgBrowsers.gecko.extensions;
        search = {
          force = true;
          default = cfgS.defaultEngine;
          privateDefault = cfg.S.private.defaultEngine;
          engines = cfgBrowsers.search.engines;
        };
      };
    };

    systemConfig.defaults.webBrowser = lib.mkIf cfg.defaultBrowser {
      command = "${pkgs.librewolf}/bin/librewolf";
      desktopName = "librewolf.desktop";
    };
  };
}
