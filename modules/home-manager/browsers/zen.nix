{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];
  options = {
    browsers.zen-browser.enable = lib.mkEnableOption "Enables Zen browser";
  };
  config = lib.mkIf config.browsers.zen-browser.enable {
    programs.zen-browser = {
      enable = true;

      policies = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });

        mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry = {
          id,
          pinned ? false,
        }: let
          base = {
            install_url = mkPluginUrl id;
            installation_mode = "force_installed";
          };
        in
          if pinned
          then base // {default_area = "navbar";}
          else base;

        mkExtensionSettings = builtins.mapAttrs (_: entry:
          if builtins.isAttrs entry
          then entry
          else mkExtensionEntry {id = entry;});
      in {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        SanitizeOnShutdown = {
          Cookies = true;
        };
        Cookies = {
          Allow = [
            "https://proton.me"
            "https://youtube.com"
            "https://github.com"
            "https://gitlab.com"
            "https://nano-gpt.com"
            "https://perplexity.ai"
          ];
        };

        ExtensionSettings = mkExtensionSettings {
          "uBlock0@raymondhill.net" = mkExtensionEntry {
            id = "ublock-origin";
            pinned = true;
          };
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = mkExtensionEntry {
            id = "proton-pass";
            pinned = true;
          };
          "search@kagi.com" = "kagi-search-for-firefox";
          "deArrow@ajay.app" = "dearrow";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
        };

        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          # "browser.tabs.warnOnClose" = false;
          # "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
          "browser.gesture.swipe.left" = "";
          "browser.gesture.swipe.right" = "";
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;

          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;

          # "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
        };
      };

      profiles."default" = rec {
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.welcome-screen.seen" = true;
          "browser.backspace_action" = 0;
          "media.videocontrols.picture-in-picture.enabled" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
        };

        bookmarks = {
          force = true;
          settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  name = "Programming";
                  bookmarks = [
                    {
                      name = "Zig Docs";
                      url = "https://ziglang.org/documentation/";
                      tags = ["wiki" "zig" "programming"];
                    }
                    {
                      name = "jujutsu";
                      url = "https://jj-vcs.github.io/jj/latest/";
                      tags = ["wiki" "guide" "git" "jj" "programming"];
                    }
                  ];
                }
                {
                    name = "Nano Gpt";
                    url = "https://nano-gpt.com/conversation/new";
                }
              ];
            }
          ];
        };

        pinsForce = true;
        pins = {
          Music = {
            id = "04b980ef-0fb1-447e-9ff9-23f2fcf5dd2c";
            workspace = spaces.YouTube.id;
            url = "https://www.youtube.com/results?search_query=my+mix";
            position = 1;
            isEssential = false;
            container = containers."Google".id;
          };
          GitHub = {
            id = "962ebf2c-d92e-438f-aab9-193cccb49054";
            workspace = spaces.Programming.id;
            url = "https://github.com";
            position = 2;
            isEssential = false;
            container = containers."Programming".id;
          };
          GitLab = {
            id = "24fa2a42-d903-46af-8b03-c49a5b369ed8";
            workspace = spaces.Programming.id;
            url = "https://gitlab.com";
            position = 3;
            isEssential = false;
            container = containers."Programming".id;
          };
          School = {
            id = "2115af96-33d6-4b3e-9fe9-3756d8507a53";
            workspace = spaces.School.id;
            url = "https://unicornuniversity.net";
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
          default = "Kagi";
          privateDefault = "Kagi";
          engines = {
            Kagi = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@k" "@kagi"];
            };
            perplexity.metaData.alias = "@p";
            google.metaData.hidden = true;
            bing.metaData.hidden = true;
          };
        };

        containersForce = true;
        containers = {
          Google = {
            color = "red";
            icon = "fingerprint";
            id = 1;
          };
          Programming = {
            color = "purple";
            icon = "pet";
            id = 2;
          };
          School = {
            color = "blue";
            icon = "circle";
            id = 3;
          };
          Proton = {
            color = "purple";
            icon = "fingerprint";
            id = 4;
          };
        };
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
  };
}
