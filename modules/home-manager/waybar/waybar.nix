{
  config,
  lib,
  pkgs,
  ...
}: let
  hyprland-features =
    if config.waybar.hyprland.enable
    then [
      "hyprland/workspaces"
      # "custom/hyprland-music"
      "custom/separator"
      "hyprland/submap"
      "custom/separator"
      "hyprland/window"
      "custom/separator"
      "custom/fullscreen"
    ]
    else [];
  mullvad-features =
    if config.waybar.mullvad.enable
    then ["custom/separator" "custom/mullvad"]
    else [];
  load-features =
    if config.waybar.load.enable
    then [
      "cpu"
      "load"
      "memory"
      "custom/separator"
    ]
    else [];
  wallpaper-features =
    if config.waybar.wallpaper.enable
    then [
      "custom/separator"
      "custom/wallpaper-category"
    ]
    else [];
in {
  imports = [
    ../../nixos/desktop-variables/variables.nix
  ];

  options.waybar = {
    hyprland.enable = lib.mkEnableOption "Enable hyprland features";
    mullvad.enable = lib.mkEnableOption "Enable mullvad features";
    load.enable = lib.mkEnableOption "Enable load features";
    wallpaper.enable = lib.mkEnableOption "Enable wallpaper features";

    weatherCity = lib.mkOption {
      type = lib.types.str;
      default = "Prague";
      description = "Set the target city for weather";
    };
  };

  config = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          "modules-left" =
            hyprland-features
            ++ wallpaper-features;
          "modules-center" = ["clock" "privacy"];
          "modules-right" =
            load-features
            ++ [
              "network"
              "custom/separator"
              "cava"
              "pulseaudio"
              "custom/separator"
              "custom/weather"
            ]
            ++ mullvad-features ++ ["custom/separator" "tray" "custom/separator" "custom/shutdown"];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              urgent = "!";
            };
          };

          "hyprland/window" = {
            max-length = 40;
          };

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
            interval = 1;
            tooltip = false;
          };

          pulseaudio = {
            format = "Volume: {volume}%";
            on-click = "pavucontrol";
          };

          network = {
            # interface = "enp42s0";
            interval = 5;
            format-disconnected = "Disconnected";
            # format-ethernet = "UP: {bandwidthUpBytes} | DOWN: {bandwidthDownBytes}";
            format-ethernet = "Ethernet";
            tooltip-format = "UP: {bandwidthUpBytes} | DOWN: {bandwidthDownBytes}\n{ifname}: {ipaddr}/{cidr}";
          };

          cpu = {
            format = "CPU: {usage}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          load = {
            format = "LOAD: {}";
            interval = 1;
          };

          memory = {
            format = "RAM: {percentage}%";
            tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed}G/{swapTotal}G";
            interval = 5;
            states = {
              warning = 70;
              critical = 90;
            };
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

          "custom/hyprland-music" = {
            format = "M";
            tooltip-format = "Toggles music workspace";
            on-click = "hyprctl dispatch togglespecialworkspace music";
          };

          "custom/separator" = {
            format = "│";
            tooltip = false;
          };

          "custom/shutdown" = {
            format = "X";
            tooltip = false;
            on-click = "~/.local/bin/shutdown-menu.sh";
          };

          "custom/wallpaper-category" = {
            exec = "basename $(hyprpaper-random-control get-current)";
            format = "Wallpaper: {}";
            interval = 1;
          };

          "custom/fullscreen" = {
            exec = "$HOME/.config/waybar/scripts/fullscreen";
            interval = 1;
            format = "{}";
          };

          "custom/mullvad" = {
            format = "Mullvad: {}";
            exec = "$HOME/.config/waybar/scripts/mullvad-status";
            interval = 30;
            on-click = "mullvad connect && sleep 1 && pkill -RTMIN+10 waybar";
            on-click-right = "mullvad disconnect && sleep 1 && pkill -RTMIN+10 waybar";
            return-type = "json";
          };

          "custom/weather" = {
            exec = "curl -s 'wttr.in/" + config.waybar.weatherCity + "?format=1' | head -c 15";
            format = "{}";
            interval = 3600;
            tooltip = false;
            on-click = "pkill -RTMIN+10 waybar";
          };
        };
      };
      style = ''
        * {
            margin: 0;
            padding: 0;
        }

        #waybar {
            background-color: ${config.colorScheme.background};
            opacity: 0.8;
        }

        #workspaces,
        #window,
        #submap,
        #pulseaudio,
        #clock,
        #network,
        #tray,
        #cpu,
        #load,
        #memory,
        #privacy,
        #custom-wallpaper-category,
        #custom-mullvad,
        #custom-weather,
        #custom-shutdown,
        #custom-hyprland-music,
        #custom-fullscreen {
            border-radius: 8px;
            border: 1px solid ${config.colorScheme.accent};
            margin: 0 3px;
            padding: 0 3px;
        }

        #workspaces button.active {
            background: ${config.colorScheme.primary};
        }

        #workspaces button:hover {
            background: ${config.colorScheme.primary};
        }

        #workspaces button.urgent {
            background-color: red;
            color: white;
        }

        @keyframes flashBackground {
            0% {
                background-color: red;
            }
            50% {
                background-color: black;
            }
            100% {
                background-color: red;
            }
        }

        #network.ethernet {
            background-color: green;
        }

        #network.disconnected,
        #network.disabled {
            animation-name: flashBackground;
            animation-iteration-count: 10;
            animation-duration: 1s;
            animation-timing-function: linear;
            background-color: red;
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

    home.file = {
      ".config/waybar/scripts/fullscreen" = lib.mkIf config.waybar.hyprland.enable {
        text = ''
          #!/usr/bin/env bash
          active=$(hyprctl activewindow -j)
          is_fullscreen=$(echo "$active" | jq '.fullscreen')

          if [ "$is_fullscreen" = "1" ]; then
            echo "Fullscreen"
          else
            echo "Window"
          fi
        '';
        executable = true;
      };
      ".config/waybar/scripts/mullvad-status" = lib.mkIf config.waybar.mullvad.enable {
        text = ''
          #!/usr/bin/env bash
          if ! status_output=$(mullvad status 2>&1); then
            echo "{\"text\": \"Error\", \"tooltip\": \"Failed to get Mullvad status\", \"class\": \"error\"}"
            exit 1
          fi

          if echo "$status_output" | grep -q "^Connected"; then
              status="Connected"
              class="connected"
              tooltip=$(echo "$status_output" | sed '1d' | sed 's/^[[:space:]]*//' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
          else
              status="Disconnected"
              class="disconnected"
              tooltip="Mullvad is not connected"
          fi

          echo "{\"text\": \"$status\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
        '';
        executable = true;
      };
    };
  };
}
