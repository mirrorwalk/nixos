{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.browsers;
in {
  options.browsers.firefox = {
    enable = lib.mkEnableOption "Enables librewolf";
    defaultBrowser = lib.mkEnableOption "Librewolf as default browser";
  };

  config = lib.mkIf cfg.firefox.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [pkgs.firefoxpwa];

      policies =
        cfg.gecko.policies
        // {
          SanitizeOnShutdown = {
            Cookies = true;
          };
          Cookies = {
            Allow = cfg.allowedCookies;
          };

          Preferences = cfg.gecko.preferences;
        };

      profiles.default = {
        extensions = cfg.gecko.extensions;
        bookmarks = cfg.gecko.bookmarks;
        settings = cfg.gecko.settings;

        search = {
          force = true;
          default = cfg.search.defaultEngine;
          privateDefault = cfg.search.private.defaultEngine;
          engines = cfg.search.engines;
        };

        containersForce = true;
        containers = cfg.gecko.containers;
      };
    };
  };
}
