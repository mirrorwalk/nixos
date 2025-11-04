{
  lib,
  inputs,
  pkgs,
  ...
}: let
  containerSubmodule = lib.types.submodule {
    options = {
      color = lib.mkOption {
        type = lib.types.str;
      };

      icon = lib.mkOption {
        type = lib.types.str;
      };

      id = lib.mkOption {
        type = lib.types.int;
      };
    };
  };

  inherit (lib) mkOption types;

  bookmarkSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [];
      };

      keyword = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      url = mkOption {
        type = types.str;
      };
    };
  };

  bookmarkType = types.addCheck bookmarkSubmodule (x: x ? "url");

  directoryType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
      };

      bookmarks = mkOption {
        type = types.listOf bookmarksType;
        default = [];
      };

      toolbar = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  separatorType = types.enum ["separator"];

  # bookmarksType = types.either bookmarkType directoryType;
  bookmarksType = types.oneOf [bookmarkType directoryType separatorType];
in {
  options.browsers.gecko = {
    extensions = lib.mkOption {
      description = "gecko extensions";
      type = lib.types.attrs;
      default = {
        force = true;
        packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          proton-pass
          sponsorblock
          return-youtube-dislikes
          dearrow
          kagi-search
        ];
      };
    };

    bookmarks = {
      force = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
      settings = lib.mkOption {
        description = "Gecko bookmarks";
        # type = lib.types.listOf lib.types.attrs;
        type = lib.types.listOf bookmarksType;
      };
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        "browser.backspace_action" = 0;
        "media.videocontrols.picture-in-picture.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
      };
    };

    policies = lib.mkOption {
      type = lib.types.attrs;

      default = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        DisableFirefoxAccounts = true;
        DisableSafeMode = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    };

    preferences = lib.mkOption {
      default = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });
      in
        mkLockedAttrs {
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

    containers = lib.mkOption {
      type = lib.types.attrsOf containerSubmodule;
    };
  };

  config.browsers.gecko = {
    bookmarks.settings = [
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
                keyword = "zig";
              }
              {
                name = "jujutsu";
                url = "https://jj-vcs.github.io/jj/latest/";
                tags = ["wiki" "guide" "git" "jj" "programming"];
                keyword = "jj";
              }
            ];
          }
          "separator"
          {
            name = "Nano Gpt";
            url = "https://nano-gpt.com/conversation/new";
            tags = ["ai"];
          }
          {
            name = "NixOS";
            bookmarks = [
              {
                name = "Nixpkgs Search";
                url = "https://search.nixos.org";
                tags = ["nix"];
              }
              {
                name = "My NixOS";
                url = "https://mynixos.com/";
                tags = ["nix"];
                keyword = "nix";
              }
              {
                name = "Home Manager Options";
                url = "https://home-manager-options.extranix.com/";
                tags = ["nix"];
              }
              {
                name = "Nixpkgs References";
                url = "https://nixos.org/manual/nixpkgs/stable/";
                tags = ["nix"];
              }
            ];
          }
        ];
      }
    ];

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
  };
}
