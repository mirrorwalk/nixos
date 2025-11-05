{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.browsers;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
    ./zen-keyboard-shortcuts.nix
  ];

  options.browsers.zen-browser = {
    enable = lib.mkEnableOption "Enables Zen browser";
    defaultBrowser = lib.mkEnableOption "Mullvad as default browser";
  };

  config = lib.mkIf cfg.zen-browser.enable {
    programs.zen-browser = {
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

      profiles.default = rec {
        extensions = cfg.gecko.extensions;
        # extensions = {
        #     force = cfg.gecko.extensions.force;
        #     packages = cfg.gecko.extensions.packages;
        # };
        bookmarks = cfg.gecko.bookmarks;
        settings =
          cfg.gecko.settings
          // {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.animate-sidebar" = false;
            "zen.welcome-screen.seen" = true;
          };

        pinsForce = true;
        pins = {
          Music = {
            id = "04b980ef-0fb1-447e-9ff9-23f2fcf5dd2c";
            workspace = spaces.YouTube.id;
            url = "https://www.youtube.com/results?search_query=my+mix";
            position = 1;
            isEssential = false;
            container = containers.Google.id;
          };

          GitHub = {
            id = "962ebf2c-d92e-438f-aab9-193cccb49054";
            workspace = spaces.Programming.id;
            url = "https://github.com";
            position = 2;
            isEssential = false;
            container = containers.Programming.id;
          };

          GitLab = {
            id = "24fa2a42-d903-46af-8b03-c49a5b369ed8";
            workspace = spaces.Programming.id;
            url = "https://gitlab.com";
            position = 3;
            isEssential = false;
            container = containers.Programming.id;
          };

          School = {
            id = "2115af96-33d6-4b3e-9fe9-3756d8507a53";
            workspace = spaces.School.id;
            url = "https://unicornuniversity.net/cs";
            position = 4;
            isEssential = false;
            container = containers.School.id;
          };

          Proton-Mail = {
            id = "ac5aad93-e1fe-4c7a-8253-9deda8c39721";
            workspace = spaces.Proton.id;
            url = "https://mail.proton.me";
            position = 5;
            isEssential = false;
            container = containers.Proton.id;
          };
        };

        search = {
          force = true;
          default = cfg.search.defaultEngine;
          privateDefault = cfg.search.private.defaultEngine;
          # if cfg.search.private.same
          # then cfg.search.defaultEngine
          # else cfg.search.private.defaultEngine;
          engines = cfg.search.engines;
        };

        containersForce = true;
        containers = cfg.gecko.containers;

        spacesForce = true;
        spaces = {
          General = {
            id = "178f0a7f-e847-4e02-b719-80a630cbf1fe";
            icon = "💻";
            position = 1;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 0;
                  green = 0;
                  blue = 0;
                  algorithm = "floating";
                }
                {
                  red = 255;
                  green = 255;
                  blue = 255;
                  algorithm = "floating";
                }
                {
                  red = 255;
                  green = 0;
                  blue = 0;
                  algorithm = "floating";
                }
              ];
              rotation = 45;
              opacity = 0.2;
              texture = 0.5;
            };
          };
          YouTube = {
            id = "0c5553b8-f4a8-4d19-b92f-bc20cfdc86be";
            icon = "🎞️";
            position = 2;
            container = containers.Google.id;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 10;
                  green = 10;
                  blue = 10;
                }
                {
                  red = 180;
                  green = 0;
                  blue = 0;
                }
              ];
              opacity = 0.8;
              texture = 0.2;
            };
          };
          Proton = {
            id = "f043bec2-430b-4151-9428-4e0b236839bd";
            container = containers.Proton.id;
            position = 3;
          };
          Programming = {
            id = "7ede9b51-a443-44ff-911a-9590c6df8816";
            icon = "👨‍💻";
            position = 4;
            container = containers.Programming.id;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 0;
                  green = 0;
                  blue = 0;
                }
                {
                  red = 255;
                  green = 255;
                  blue = 255;
                }
                {
                  red = 0;
                  green = 0;
                  blue = 255;
                }
              ];
              opacity = 0.7;
            };
          };
          School = {
            id = "4f9a74ce-0c8b-4977-a4c8-18a44e3859f5";
            icon = "🏫";
            position = 5;
            container = containers.School.id;
            theme = {
              colors = [
                {
                  red = 0;
                  green = 0;
                  blue = 255;
                }
              ];
            };
          };
        };
      };
    };

    systemConfig.defaults = lib.mkIf cfg.zen-browser.defaultBrowser {
      webBrowser = let
        zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
        desktopFile = zen-browser.meta.desktopFileName;
      in {
        desktopName = desktopFile;
        command = "${zen-browser}/bin/zen-twilight";
      };
    };
  };
}
