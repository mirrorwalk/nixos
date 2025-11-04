{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.bars.waybar;
  cScheme = config.styleConfig.colorScheme;

  fullscreenScript = pkgs.writeShellScriptBin "fullscreen" ''
    #!/usr/bin/env bash
    active=$(hyprctl activewindow -j)
    is_fullscreen=$(echo "$active" | jq '.fullscreen')

    [[ "$is_fullscreen" == "1" ]] && echo "Fullscreen" || echo "Window"
  '';

  mullvadStatus = pkgs.writeShellScriptBin "mullvad-status" ''
    #!/usr/bin/env bash
    if ! status_output=$(mullvad status 2>&1); then
      echo '{"text": "Error", "tooltip": "Failed to get Mullvad status", "class": "error"}'
      exit 1
    fi

    if echo "$status_output" | grep -q "^Connected"; then
      status="Connected"
      class="connected"
      tooltip=$(echo "$status_output" | sed '1d; s/^[[:space:]]*//; s/"/\\"/g; :a;N;$!ba;s/\n/\\n/g')
    else
      status="Disconnected"
      class="disconnected"
      tooltip="Mullvad is not connected"
    fi

    echo "{\"text\": \"$status\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
  '';

  isEnabled = modules: enabled:
    if enabled
    then modules
    else [];
in {
  options.bars.waybar = {
    enable = mkEnableOption "Enable waybar";

    modules = {
      left = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      right = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      center = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };

    backlight.enable = mkEnableOption "Enable backlight module";
    cklight.enable = mkEnableOption "Enable backlight module";

    weather = {
      enable = mkEnableOption "Enable weather module";
      city = mkOption {
        type = types.str;
        default = "Prague";
        description = "City for weather information";
      };
    };

    mullvadVPN.enable = mkEnableOption "Enable mullvad-vpn module";

    interval = mkOption {
      type = types.int;
      default = 1;
    };

    hyprland.enable = mkEnableOption "Enable hyprland module";

    cava.enable = mkEnableOption "Enable cava module";

    battery.enable = mkEnableOption "Enable battery module";

    wallpaperCategory = {
      enable = mkEnableOption "Enable wallpaper category module";
      settings = {
        command = mkOption {
          type = types.str;
          example = "basename $(hyprpaper-random-control get-current)";
          default = "";
        };
      };
    };

    systemService.enable = mkEnableOption "Enable waybar systemd service";
  };

  config = mkIf cfg.enable {
    bars.waybar = {
      modules.left =
        isEnabled [
          "hyprland/workspaces"
          # "custom/separator"
          "hyprland/submap"
          # "custom/separator"
          "hyprland/window"
          "custom/separator"
          "custom/fullscreen"
        ]
        cfg.hyprland.enable
        ++ [
          "custom/separator"
        ] ++ isEnabled
        ["backlight"] cfg.backlight.enable
        ++ [
          "custom/separator"
        ]
        ++ isEnabled [
          "custom/wallpaper-category"
        ]
        cfg.wallpaperCategory.enable;
      modules.center = ["clock" "privacy"];
      modules.right =
        [
          "network"
        ]
        ++ isEnabled [
          "custom/mullvad"
        ]
        cfg.mullvadVPN.enable
        ++ [
          "custom/separator"
          "pulseaudio"
        ]
        ++ isEnabled [
          "cava"
        ]
        cfg.cava.enable
        ++ [
          "custom/separator"
        ]
        ++ isEnabled [
          "custom/weather"
        ]
        cfg.weather.enable
        ++ [
          "custom/separator"
          "tray"
          "custom/separator"
        ]
        ++ isEnabled [
          "battery"
        ]
        cfg.battery.enable;
    };

    programs.waybar = {
      enable = true;

      settings.mainBar = {
        modules-left = cfg.modules.left;
        modules-right = cfg.modules.right;
        modules-center = cfg.modules.center;

        cava = mkIf cfg.cava.enable {
          framerate = 30;
          autosens = 1;
          bars = 14;
          input_delay = 2;
          stereo = true;
          bar_delimiter = 0;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        };

        network = {
          format = "Connected";
          format-disconnected = "Disconnected";
          format-disabled = "Disabled";
          tooltip-format = "UP: {bandwidthUpBytes} | DOWN: {bandwidthDownBytes}\n{ifname}: {ipaddr}/{cidr}";
        };

        clock = {
          format = "{:%T %F}";
          interval = cfg.interval;
          tooltip = false;
        };

        pulseaudio = {
          format = "Volume: {volume}%";
          format-muted = "Muted: {volume}%";
          scroll-step = 5;
          on-click = "pavucontrol";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons.urgent = "!";
        };

        "hyprland/window".max-length = 40;

        privacy = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
          ignore = [
            {
              type = "audio-in";
              name = "cava";
            }
          ];
        };

        battery = mkIf cfg.battery.enable {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
        };

        "custom/wallpaper-category" = mkIf cfg.wallpaperCategory.enable {
          exec = cfg.wallpaperCategory.settings.command;
          format = "Wallpaper: {}";
          interval = cfg.interval;
        };

        "custom/separator" = {
          format = "│";
          tooltip = false;
        };

        "custom/fullscreen" = {
          exec = "${fullscreenScript}/bin/fullscreen";
          interval = cfg.interval;
          format = "{}";
        };

        "custom/weather" = mkIf cfg.weather.enable {
          exec = "curl -s 'wttr.in/${cfg.weather.city}?format=1' | head -c 15";
          format = "{}";
          interval = 3600;
          tooltip = false;
          on-click = "pkill -RTMIN+10 waybar";
        };

        "custom/mullvad" = mkIf cfg.mullvadVPN.enable {
          format = "Mullvad: {}";
          exec = "${mullvadStatus}/bin/mullvad-status";
          interval = cfg.interval;
          on-click = "mullvad connect && sleep 1 && pkill -RTMIN+10 waybar";
          on-click-right = "mullvad disconnect && sleep 1 && pkill -RTMIN+10 waybar";
          return-type = "json";
        };
      };

      style = ''
        * {
          margin: 0;
          padding: 0;
        }

        #waybar {
          background-color: ${cScheme.secondary};
          opacity: 0.8;
        }

        ${
          if cfg.weather.enable
          then "#custom-weather,"
          else ""
        }
        ${
          if cfg.mullvadVPN.enable
          then "#custom-mullvad,"
          else ""
        }
        ${
          if cfg.wallpaperCategory.enable
          then "#custom-wallpaper-category,"
          else ""
        }
        ${
          if cfg.battery.enable
          then "#battery,"
          else ""
        }
        ${
          if cfg.hyprland.enable
          then ''
            #workspaces,
            #window,
            #submap,
            #custom-fullscreen,
          ''
          else ""
        }
        #pulseaudio,
        #clock,
        #backlight,
        #network,
        #tray,
        #privacy
         {
          border-radius: 8px;
          border: 1px solid ${cScheme.accent};
          margin: 0 3px;
          padding: 0 3px;
        }

        #network {
          background-color: green;
        }

        #network.disconnected,
        #network.disabled {
          background-color: red;
        }

        ${
          if cfg.mullvadVPN.enable
          then ''
            #custom-mullvad.disconnected {
                background-color: red;
            }

            #custom-mullvad.connected {
              background-color: green;
            }
          ''
          else ""
        }

        ${
          if cfg.hyprland.enable
          then ''
            #workspaces button.active,
            #workspaces button:hover {
              background: ${cScheme.primary};
            }

            #workspaces button.urgent {
              background-color: red;
              color: white;
            }
          ''
          else ""
        }

        ${
          if cfg.battery.enable
          then ''
            #battery.warning {
              background-color: orange;
            }

            #battery.critical {
              background-color: red;
            }

            #battery.charging {
              background-color: green;
            }
          ''
          else ""
        }

      '';
    };

    systemd.user.services.waybar = lib.mkIf cfg.systemService.enable {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
        Documentation = "https://github.com/Alexays/Waybar/wiki";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };

      Install = {
        WantedBy = [
          "graphical-session.target"
          "hyprland-session.target"
        ];
      };
    };
  };
}
