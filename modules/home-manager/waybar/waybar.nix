{
  home.file = {
    ".config/waybar/scripts/fullscreen" = {
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
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 8;
        "margin-top" = 5;
        "margin-left" = 10;
        "margin-right" = 10;

        "modules-left" = [
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/window"
          "custom/separator"
          "custom/fullscreen"
          "custom/separator"
          "custom/wallpaper-category"
        ];
        "modules-center" = [
          "clock"
        ];
        "modules-right" = [
          "cpu"
          "load"
          "memory"
          "network"
          "custom/separator"
          "pulseaudio"
          "custom/separator"
          "custom/weather"
          "custom/separator"
          "custom/mullvad"
          "tray"
        ];

        "niri/window" = {
          format = "{}";
          "max-length" = 40;
        };

        "custom/mullvad" = {
          format = "{}";
          exec = "mullvad status 2>/dev/null | grep -q 'Connected' && echo 'Connected' || echo 'Disconnected'";
          interval = 10;
        };

        "custom/fullscreen" = {
          exec = ".config/waybar/scripts/fullscreen";
          interval = 1;
          format = "{}";
        };

        "custom/wallpaper-category" = {
          exec = "basename $(readlink $HOME/.local/bin/random-wallpaper/hyprpaper/wallpapers)";
          format = "Wallpaper: {}";
          interval = 1;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          "format-icons" = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎭";
            "5" = "󰎱";
            "6" = "󰎳";
            "7" = "󰎶";
            "8" = "󰎹";
            "9" = "󰎼";
            "10" = "󰎡";
          };
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          "on-click" = "activate";
        };

        "hyprland/window" = {
          format = "{}";
          "max-length" = 40;
          "separate-outputs" = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌐 $1";
            "(.*) - Discord" = "💬 $1";
            "(.*) - VSCode" = "💻 $1";
            "kitty" = "⚡ Terminal";
          };
        };

        "hyprland/submap" = {
          format = "✨ {}";
          "max-length" = 8;
          tooltip = false;
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip = true;
          interval = 2;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        memory = {
          format = "󰍛 {percentage}%";
          "tooltip-format" = "RAM: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed}G/{swapTotal}G";
          interval = 5;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        network = {
          interface = "enp42s0";
          interval = 2;
          "format-disconnected" = "❌ Disconnected";
          "format-ethernet" = "🔺{bandwidthUpBytes} 🔻{bandwidthDownBytes}";
          "tooltip-format" = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          "format-bluetooth" = "󰂯 {volume}%";
          "format-muted" = "󰖁";
          "format-icons" = {
            headphone = "󰋋";
            "hands-free" = "󰋎";
            headset = "󰋎";
            phone = "󰄜";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          "scroll-step" = 5;
          "on-click" = "pavucontrol";
          "on-click-right" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        clock = {
          format = "󰥔 {:%H:%M 󰸗 %Y-%m-%d} ";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            format = {
              months = "<span color='#ffffff'><b>{}</b></span>";
              days = "<span color='#ffffff'><b>{}</b></span>";
              weekdays = "<span color='#ffffff'><b>{}</b></span>";
              today = "<span color='#ff0000'><b><u>{}</u></b></span>";
            };
          };
        };

        "custom/separator" = {
          format = "│";
          tooltip = false;
        };

        "custom/weather" = {
          exec = "curl -s 'wttr.in/Prague?format=1' | head -c 15";
          format = "{}";
          interval = 3600;
          tooltip = false;
        };

        load = {
          format = "{}";
          interval = 1;
        };
      }
    ];
    style = ''
                * {
                    font-family: "JetBrainsMono Nerd Font", "Fira Code Nerd Font", "Hack Nerd Font", monospace;
                    font-size: 13px;
                    font-weight: bold;
                }

          #custom-mullvad {
              background: #1a1a1a;
              border-radius: 8px;
              padding: 4px 10px;
              margin: 0 3px;
              border: 1px solid #ff0000;
              color: #ffffff;
            }

                #custom-mullvad.connected {
                  color: #86efac; /* Green */
                }

                #custom-mullvad.disconnected {
                  color: #f87171; /* Red */
                }


                /* Main waybar window */
                window#waybar {
                    background: #000000;
                    border: 2px solid #ff0000;
                    border-radius: 12px;
                    color: #ffffff;
                }

                window#waybar.hidden {
                    opacity: 0.3;
                }

                .modules-left,
                .modules-center,
                .modules-right {
                    margin: 0;
                    padding: 0;
                }

                #workspaces,
                #custom-niri-window
                #tray{
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 2px;
                    margin: 0 5px;
                    border: 1px solid #ff0000;
                }

                #workspaces button {
                    padding: 4px 8px;
                    background: transparent;
                    color: #ffffff;
                    border: none;
                    border-radius: 6px;
                    margin: 2px;
                }

                #workspaces button:hover {
                    background: #ff0000;
                    color: #000000;
                }

                #workspaces button.active {
                    background: #ff0000;
                    color: #000000;
                }

                #workspaces button.urgent {
                    background: #ff0000;
                    color: #ffffff;
                }

                /* Window title */
                #window {
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 4px 12px;
                    margin: 0 5px;
                    color: #ffffff;
                    border: 1px solid #ff0000;
                    min-width: 200px;
                }

                /* System monitoring modules */
                #cpu,
                #load,
                #network,
                #memory {
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 4px 10px;
                    margin: 0 3px;
                    border: 1px solid #ff0000;
                    color: #ffffff;
                }

                #cpu.warning,
                #memory.warning {
                    background: #ffffff;
                    color: #ff0000;
                }

                #cpu.critical,
                #memory.critical {
                    background: #ff0000;
                    color: #ffffff;
                }

                #pulseaudio,
                #custom-weather {
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 4px 10px;
                    margin: 0 3px;
                    border: 1px solid #ff0000;
                    color: #ffffff;
                }

                #pulseaudio.muted {
                    background: #1a1a1a;
                    color: #888888;
                }

                /* Clock */
                #clock {
                    background: #1a1a1a;
                    border-radius: 10px;
                    padding: 6px 15px;
                    margin: 0 5px;
                    border: 2px solid #ff0000;
                    color: #ffffff;
                    font-weight: bold;
                }

                /* Custom modules */
                #custom-power {
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 4px 8px;
                    margin: 0 3px;
                    border: 1px solid #ff0000;
                    color: #ffffff;
                }

                #custom-power:hover {
                    background: #ff0000;
                    color: #000000;
                }

                #custom-separator {
                    color: #ff0000;
                    margin: 0 5px;
                    font-weight: normal;
                }

                /* Submap indicator */
                #submap {
                    background: #1a1a1a;
                    border-radius: 8px;
                    padding: 4px 10px;
                    margin: 0 3px;
                    border: 1px solid #ff0000;
                    color: #ffffff;
                }

                /* Hover effects for all modules */
                #cpu:hover,
                #load:hover,
                #memory:hover,
                #network:hover,
                #pulseaudio:hover,
                #clock:hover,
                #custom-weather:hover {
                    background: #ff0000;
                    color: #000000;
                }

                /* Tooltip styling */
                tooltip {
                    background: #000000;
                    border: 1px solid #ff0000;
                    border-radius: 8px;
                    color: #ffffff;
                }

                tooltip label {
                    color: #ffffff;
                }
    '';
  };
}
