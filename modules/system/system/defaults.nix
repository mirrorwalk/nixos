{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.systemConfig.defaults;
in {
  options.systemConfig.defaults = {
    enable = lib.mkEnableOption "Enable xdg default setup";

    notifications = {
      command = mkOption {
        default = "${pkgs.mako}/bin/mako";
        type = types.str;
      };
    };

    brightness = {
      enable = lib.mkEnableOption "enable brightness defaults";

      command = {
        increase = mkOption {
          default = "${pkgs.brightnessctl}/bin/brightnessctl set +${toString cfg.brightness.step}%";
          type = types.str;
        };
        decrease = mkOption {
          default = "${pkgs.brightnessctl}/bin/brightnessctl set ${toString cfg.brightness.step}%-";

          type = types.str;
        };
      };

      step = mkOption {
        default = 5;
        type = types.int;
      };
    };

    fileManager = {
      command = mkOption {
        type = types.str;
        default = "${pkgs.xfce.thunar}/bin/thunar";
      };

      desktopName = mkOption {
        type = types.str;
        default = "thunar.desktop";
      };

      associations = mkOption {
        type = types.listOf types.str;
        default = [
          "inode/directory"
        ];
      };
    };

    webBrowser = {
      command = mkOption {
        type = types.str;
        default = "${pkgs.mullvad-browser}/bin/mullvad-browser";
      };

      associations = mkOption {
        type = types.listOf types.str;
        default = [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "text/html"
        ];
      };

      desktopName = mkOption {
        type = types.str;
        default = "mullvad-browser.desktop";
      };
    };

    runnerMenu.command = mkOption {
      type = types.str;
      default = "${pkgs.fuzzel}/bin/fuzzel";
    };

    terminal = {
      package = mkOption {
        type = types.pkgs;
        default = pkgs.ghostty;
      };

      command = mkOption {
        type = types.str;
        default = "${pkgs.ghostty}/bin/ghostty";
      };
    };

    video = {
      desktopName = mkOption {
        type = types.str;
        default = "mpv.desktop";
      };

      associations = mkOption {
        type = types.listOf types.str;
        default = [
          "video/mp4"
          "video/x-matroska"
          "video/quicktime"
          "video/x-msvideo"
          "video/x-ms-wmv"
          "video/avi"
          "video/mpeg"
        ];
      };
    };

    image = {
      desktopName = mkOption {
        type = types.str;
        default = "mpv.desktop";
      };

      associations = mkOption {
        type = types.listOf types.str;
        default = [
          "image/jpeg"
          "image/png"
          "image/gif"
          "image/webp"
          "image/svg+xml"
        ];
      };
    };

    audio = {
      desktopName = mkOption {
        type = types.str;
        default = "mpv.desktop";
      };

      associations = mkOption {
        type = types.listOf types.str;
        default = [
          "video/mp4"
          "video/ogg"
          "video/webm"
        ];
      };
    };
  };

  config = lib.mkIf config.systemConfig.defaults.enable {
    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
        ];
      };

      mimeApps = let
        default = config.systemConfig.defaults;

        associations = builtins.listToAttrs (
          lib.concatMap (
            dflt:
              map (mimeType: {
                name = mimeType;
                value = dflt.desktopName;
              })
              dflt.associations
          ) [
            default.video
            default.image
            default.webBrowser
            default.audio
            default.fileManager
          ]
        );
      in {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
    };
  };
}
