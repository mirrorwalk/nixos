{
  config,
  lib,
  ...
}: let
  hyprland-features =
    if config.waybar.hyprland.enable
    then [
      "hyprland/workspaces"
      "hyprland/submap"
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
in {
  options.waybar.hyprland.enable = lib.mkEnableOption "Enable hyprland features";
  options.waybar.mullvad.enable = lib.mkEnableOption "Enable mullvad features";
  options.waybar.load.enable = lib.mkEnableOption "Enable load features";

  config = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          "modules-left" =
            hyprland-features
            ++ [
              "custom/separator"
              "custom/wallpaper-category"
            ];
          "modules-center" = ["clock"];
          "modules-right" =
            load-features
            ++ [
              "network"
              "custom/separator"
              "pulseaudio"
              "custom/separator"
              "custom/weather"
            ]
            ++ mullvad-features ++ ["tray"];

          clock = {
            format = "{:%H:%M %Y-%m-%d}";
          };

          pulseaudio = {
            format = "Volume: {volume}%";
            on-click = "pavucontrol";
          };

          network = {
            interface = "enp42s0";
            interval = 5;
            format-disconnected = "❌ Disconnected";
            format-ethernet = "🔺{bandwidthUpBytes} 🔻{bandwidthDownBytes}";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
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

          "custom/separator" = {
            format = "│";
            tooltip = false;
          };

          "custom/wallpaper-category" = {
            exec = "basename $(readlink $HOME/.local/bin/random-wallpaper/hyprpaper/wallpapers)";
            format = "Wallpaper: {}";
            interval = 1;
          };

          "custom/fullscreen" = {
            exec = "$HOME/.config/waybar/scripts/fullscreen";
            interval = 1;
            format = "{}";
          };

          "custom/mullvad" = {
            format = "{}";
            exec = "mullvad status 2>/dev/null | grep -q 'Connected' && echo 'Mullvad Connected' || echo 'Mullvad Disconnected'";
            interval = 10;
            on-click = "mullvad connect";
            on-click-right = "mullvad connect";
          };

          "custom/weather" = {
            exec = "curl -s 'wttr.in/Prague?format=1' | head -c 15";
            format = "{}";
            interval = 3600;
            tooltip = false;
          };
        };
      };
      style = ''
        * {
            margin: 0;
            padding: 0;
        }

        #waybar {
            background-color: black;
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
        #custom-wallpaper-category,
        #custom-mullvad,
        #custom-weather,
        #custom-fullscreen {
            border-radius: 8px;
            border: 1px solid red;
            margin: 0 3px;
            padding: 0 3px;
        }


        #workspaces button.active {
            background: red;
            color: white;
        }

        #workspaces button:hover {
            background: white;
            color: red;
        }

        #workspaces button.urgent {
            background: #ff0000;
            color: #ffffff;
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
      ".config/waybar/scripts/mullvad" = lib.mkIf config.waybar.mullvad.enable {
        text = ''
          #!/usr/bin/env bash
          if ! status_output=$(mullvad status 2>&1); then
              echo "{\"text\": \"⚠️\", \"tooltip\": \"Failed to get Mullvad status\"}"
              exit 1
          fi

          if echo "$status_output" | grep -q "^Connected"; then
              status="✅"

              tooltip=$(echo "$status_output" | sed '1d' | sed 's/^[[:space:]]*//' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
          else
              status="❌"
              tooltip="Mullvad is not connected"
          fi

          echo "{\"text\": \"$status\", \"tooltip\": \"$tooltip\"}"
        '';
        executable = true;
      };
    };
  };
}
