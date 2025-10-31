{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.waybar;
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

  # Helper to collect modules by position from enabled features
  getModulesFor = position: features:
    lib.flatten (lib.mapAttrsToList (
        name: feat:
          lib.optionals feat.enable (feat.${position} or [])
      )
      features);

  # Helper to merge settings from enabled features
  getSettings = features:
    lib.mkMerge (lib.mapAttrsToList (
        name: feat:
          lib.mkIf feat.enable feat.settings
      )
      features);

  # Helper to concatenate styles from enabled features
  getStyles = features:
    lib.concatStringsSep "\n" (lib.mapAttrsToList (
        name: feat:
          lib.optionalString feat.enable feat.style
      )
      features);
in {
  imports = [../../nixos/desktop-variables/variables.nix];

  options.waybar = {
    weatherCity = lib.mkOption {
      type = lib.types.str;
      default = "Prague";
      description = "City for weather information";
    };

    interval = lib.mkOption {
      type = lib.types.int;
      default = 1;
    };

    systemService = lib.mkEnableOption "Enable waybar systemd service";

    # Hyprland feature module
    hyprland = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Hyprland integration";

          modulesLeft = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "hyprland/workspaces"
              "custom/separator"
              "hyprland/submap"
              "custom/separator"
              "hyprland/window"
              "custom/separator"
              "custom/fullscreen"
            ];
          };

          modulesCenter = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesRight = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              "hyprland/workspaces" = {
                format = "{icon}";
                format-icons.urgent = "!";
              };

              "hyprland/window".max-length = 40;

              "custom/fullscreen" = {
                exec = "${fullscreenScript}/bin/fullscreen";
                interval = cfg.interval;
                format = "{}";
              };
            };
          };

          style = lib.mkOption {
            type = lib.types.str;
            default = ''
              #workspaces,
              #window,
              #submap,
              #custom-fullscreen {
                border-radius: 8px;
                border: 1px solid ${cScheme.accent};
                margin: 0 3px;
                padding: 0 3px;
              }

              #workspaces button.active,
              #workspaces button:hover {
                background: ${cScheme.primary};
              }

              #workspaces button.urgent {
                background-color: red;
                color: white;
              }
            '';
          };
        };
      };
      default = {};
    };

    # Mullvad feature module
    mullvad = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Mullvad VPN status";

          modulesLeft = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesCenter = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesRight = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["custom/separator" "custom/mullvad"];
          };

          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              "custom/mullvad" = {
                format = "Mullvad: {}";
                exec = "${mullvadStatus}/bin/mullvad-status";
                interval = cfg.interval;
                on-click = "mullvad connect && sleep 1 && pkill -RTMIN+10 waybar";
                on-click-right = "mullvad disconnect && sleep 1 && pkill -RTMIN+10 waybar";
                return-type = "json";
              };
            };
          };

          style = lib.mkOption {
            type = lib.types.str;
            default = ''
              #custom-mullvad {
                border-radius: 8px;
                border: 1px solid ${cScheme.accent};
                margin: 0 3px;
                padding: 0 3px;
              }

              @keyframes flashBackground {
                0% { background-color: red; }
                50% { background-color: black; }
                100% { background-color: red; }
              }

              #custom-mullvad.disconnected {
                animation-name: flashBackground;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                background-color: black;
              }

              #custom-mullvad.connected {
                background-color: green;
              }
            '';
          };
        };
      };
      default = {};
    };

    # Load monitoring feature module
    load = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "System load monitoring";

          modulesLeft = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesCenter = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesRight = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["cpu" "load" "memory" "custom/separator"];
          };

          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              cpu = {
                format = "CPU: {usage}%";
                states = {
                  warning = 70;
                  critical = 90;
                };
              };
              load = {
                format = "LOAD: {}";
                interval = cfg.interval;
              };
              memory = {
                format = "RAM: {percentage}%";
                tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed}G/{swapTotal}G";
                interval = cfg.interval;
                states = {
                  warning = 70;
                  critical = 90;
                };
              };
            };
          };

          style = lib.mkOption {
            type = lib.types.str;
            default = ''
              #cpu,
              #load,
              #memory {
                border-radius: 8px;
                border: 1px solid ${cScheme.accent};
                margin: 0 3px;
                padding: 0 3px;
              }
            '';
          };
        };
      };
      default = {};
    };

    # Wallpaper feature module
    wallpaper = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Wallpaper control";

          modulesLeft = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["custom/separator" "custom/wallpaper-category"];
          };

          modulesCenter = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          modulesRight = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              "custom/wallpaper-category" = {
                exec = "basename $(hyprpaper-random-control get-current)";
                format = "Wallpaper: {}";
                interval = cfg.interval;
              };
            };
          };

          style = lib.mkOption {
            type = lib.types.str;
            default = ''
              #custom-wallpaper-category {
                border-radius: 8px;
                border: 1px solid ${cScheme.accent};
                margin: 0 3px;
                padding: 0 3px;
              }
            '';
          };
        };
      };
      default = {};
    };
  };

  config = let
    features = {
      inherit (cfg) hyprland mullvad load wallpaper;
    };
  in {
    programs.waybar = {
      enable = true;

      settings.mainBar = lib.mkMerge [
        {
          "modules-left" = getModulesFor "modulesLeft" features;

          "modules-center" = ["clock" "privacy"] ++ getModulesFor "modulesCenter" features;

          "modules-right" =
            getModulesFor "modulesRight" features
            ++ [
              "network"
              "custom/separator"
              "cava"
              "pulseaudio"
              "custom/separator"
              "custom/weather"
              "custom/separator"
              "tray"
              "custom/separator"
            ];

          # Core modules (always present)
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

          clock = {
            format = "{:%T %F}";
            interval = cfg.interval;
            tooltip = false;
          };

          pulseaudio = {
            format = "Volume: {volume}%";
            on-click = "pavucontrol";
          };

          network = {
            interval = cfg.interval;
            format-disconnected = "Disconnected";
            format-ethernet = "Ethernet";
            tooltip-format = "UP: {bandwidthUpBytes} | DOWN: {bandwidthDownBytes}\n{ifname}: {ipaddr}/{cidr}";
          };

          cava = {
            framerate = 30;
            autosens = 1;
            bars = 14;
            input_delay = 2;
            stereo = true;
            bar_delimiter = 0;
            format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };

          "custom/separator" = {
            format = "│";
            tooltip = false;
          };

          "custom/weather" = {
            exec = "curl -s 'wttr.in/${cfg.weatherCity}?format=1' | head -c 15";
            format = "{}";
            interval = 3600;
            tooltip = false;
            on-click = "pkill -RTMIN+10 waybar";
          };
        }

        (getSettings features)
      ];

      style = ''
        * {
          margin: 0;
          padding: 0;
        }

        #waybar {
          background-color: ${cScheme.secondary};
          opacity: 0.8;
        }

        /* Core module styles */
        #pulseaudio,
        #clock,
        #network,
        #tray,
        #privacy,
        #custom-weather
         {
          border-radius: 8px;
          border: 1px solid ${cScheme.accent};
          margin: 0 3px;
          padding: 0 3px;
        }

        #custom-separator {
        }

        #network.ethernet {
          background-color: green;
        }

        #network.disconnected,
        #network.disabled {
          animation-name: flashBackground;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: 10;
          background-color: red;
        }

        /* Feature-specific styles */
        ${getStyles features}
      '';
    };

    systemd.user.services.waybar = lib.mkIf cfg.systemService {
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
