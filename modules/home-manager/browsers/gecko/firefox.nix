{
  lib,
  pkgs,
  config,
  ...
}: let
  cfgBrowsers = config.browsers;
  cfg = cfgBrowsers.firefox;
  cfgS = cfg.search;
in {
  options.browsers.firefox = {
    enable = lib.mkEnableOption "Enables librewolf";
    defaultBrowser = lib.mkEnableOption "Librewolf as default browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [pkgs.firefoxpwa];

      policies =
        cfgBrowsers.gecko.policies
        // {
          SanitizeOnShutdown = {
            Cookies = true;
          };
          Cookies = {
            Allow = cfgBrowsers.allowedCookies;
          };

          Preferences = cfgBrowsers.gecko.preferences;
        };

      profiles.default = {
        extensions = cfgBrowsers.gecko.extensions;
        bookmarks = cfgBrowsers.gecko.bookmarks;
        settings = cfgBrowsers.gecko.settings;

        search = {
          force = true;
          default = cfgS.defaultEngine;
          privateDefault = cfgS.private.defaultEngine;
          engines = cfgBrowsers.search.engines;
        };

        containersForce = true;
        containers = cfgBrowsers.gecko.containers;
      };
    };
  };
}
