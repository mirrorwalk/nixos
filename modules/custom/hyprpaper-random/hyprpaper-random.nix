{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hyprpaper.random;

  pipe = "/tmp/hyprpaper-random.pipe";
  wallpaperFolders = config.styleConfig.wallpaperFolders;
  initialFolder = lib.head wallpaperFolders;

  hyprpaper-random = pkgs.writeShellScriptBin "hyprpaper-random" ''
    #!/usr/bin/env bash
    PIPE=${pipe}
    STATE_DIR="$HOME/.cache/hyprpaper-random"
    ENABLED_FILE="$STATE_DIR/enabled"
    INTERVAL_FILE="$STATE_DIR/interval"
    TIMER_PID_FILE="$STATE_DIR/timer.pid"
    WALLPAPER_FOLDER="${toString initialFolder}"

    mkdir -p "$STATE_DIR"
    echo "true" > "$ENABLED_FILE"
    echo "${toString cfg.interval}" > "$INTERVAL_FILE"

    [[ -p "$PIPE" ]] || mkfifo "$PIPE"

    cleanup() {
        [[ -f "$TIMER_PID_FILE" ]] && kill $(cat "$TIMER_PID_FILE") 2>/dev/null
        rm -f "$PIPE" "$TIMER_PID_FILE"
        exit 0
    }
    trap cleanup SIGTERM SIGINT

    change_wallpaper() {
        STATE_FILE="$HOME/.cache/hyprpaper-category-index"
        FOLDERS=(${lib.concatMapStringsSep " " (f: ''"${toString f}"'') wallpaperFolders})

        if [[ -f "$STATE_FILE" ]]; then
            CURRENT_INDEX=$(cat "$STATE_FILE")
            WALLPAPER_FOLDER="''${FOLDERS[$CURRENT_INDEX]}"
        fi

        if [[ ! -d "$WALLPAPER_FOLDER" ]]; then
            echo "Error: Directory $WALLPAPER_FOLDER does not exist"
            return 1
        fi

        WALLPAPER=$(find "$WALLPAPER_FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

        if [[ -n "$WALLPAPER" ]]; then
            echo "Setting wallpaper: $WALLPAPER"
            hyprctl hyprpaper preload "$WALLPAPER" > /dev/null 2>&1
            for MONITOR in ${lib.concatStringsSep " " (map (m: m.name) (lib.filter (m: m.enabled) config.systemConfig.monitors))}; do
              hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
            done
            hyprctl hyprpaper unload all > /dev/null 2>&1
        else
            echo "No wallpapers found in $WALLPAPER_FOLDER"
        fi
    }

    timer() {
        while true; do
            INTERVAL=$(cat "$INTERVAL_FILE")
            sleep "$INTERVAL"
            ENABLED=$(cat "$ENABLED_FILE")
            if [[ "$ENABLED" == "true" ]]; then
                echo "Timer triggered wallpaper change"
                change_wallpaper
            fi
        done
    }

    start_timer() {
        [[ -f "$TIMER_PID_FILE" ]] && kill $(cat "$TIMER_PID_FILE") 2>/dev/null
        timer &
        echo $! > "$TIMER_PID_FILE"
        echo "Timer started with PID $(cat "$TIMER_PID_FILE")"
    }

    start_timer

    change_wallpaper

    while true; do
        if read -r line < "$PIPE"; then
            cmd=$(echo "$line" | awk '{print $1}')
            args=$(echo "$line" | cut -d' ' -f2-)

            echo "Received command: $cmd $args"
            case "$cmd" in
                change)
                    ENABLED=$(cat "$ENABLED_FILE")
                    if [[ "$ENABLED" == "true" ]]; then
                        change_wallpaper
                        start_timer
                    fi
                    ;;
                enable)
                    echo "true" > "$ENABLED_FILE"
                    echo "Enabled"
                    ;;
                disable)
                    echo "false" > "$ENABLED_FILE"
                    echo "Disabled"
                    ;;
                set_folder)
                    WALLPAPER_FOLDER="$args"
                    echo "Folder set to: $WALLPAPER_FOLDER"
                    ENABLED=$(cat "$ENABLED_FILE")
                    if [[ "$ENABLED" == "true" ]]; then
                        change_wallpaper
                        start_timer
                    fi
                    ;;
                set-interval)
                    echo "$args" > "$INTERVAL_FILE"
                    echo "Interval set to: $args"
                    start_timer
                    ;;
                restart_timer)
                    start_timer
                    ;;
                quit)
                    cleanup
                    ;;
            esac
        fi
    done
  '';

  hyprpaper-random-control = pkgs.writeShellScriptBin "${cfg.scriptName}" ''
    #!/usr/bin/env bash
    PIPE=${pipe}
    STATE_FILE="$HOME/.cache/hyprpaper-category-index"
    FOLDERS=(${lib.concatMapStringsSep " " (f: ''"${toString f}"'') wallpaperFolders})

    start_daemon() {
        if [[ -p "$PIPE" ]]; then
            echo "Daemon already running"
            return 0
        fi
        systemctl --user start hyprpaper-random.service
        echo "hyprpaper-random.service started"
    }

    if [[ ! -p "$PIPE" ]] && [[ "$1" != "start" ]]; then
        echo "Error: Daemon not running (pipe not found at $PIPE)"
        echo "Start it with: hyprpaper-random-control start"
        exit 1
    fi

    change_category() {
        if [[ ''${#FOLDERS[@]} -eq 0 ]]; then
            echo "Error: No wallpaper folders configured"
            exit 1
        fi

        CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
        NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ''${#FOLDERS[@]} ))

        mkdir -p "$(dirname "$STATE_FILE")"
        echo "$NEXT_INDEX" > "$STATE_FILE"

        NEW_FOLDER="''${FOLDERS[$NEXT_INDEX]}"
        echo "Switching to category $((NEXT_INDEX + 1))/''${#FOLDERS[@]}: $NEW_FOLDER"

        echo "set_folder $NEW_FOLDER" > "$PIPE"
    }

    case "$1" in
        start)
            start_daemon
            ;;
        change-category)
            change_category
            ;;
        change|enable|disable|quit|restart_timer)
            echo "$1" > "$PIPE"
            ;;
        set-interval)
            if [[ -z "$2" ]]; then
                echo "Error: set-interval requires a value"
                exit 1
            fi
            echo "set-interval $2" > "$PIPE"
            ;;
        get-current)
            CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
            echo "''${FOLDERS[$CURRENT_INDEX]}"
            ;;
        *)
            echo "Usage: $0 {start|change|change-category|enable|disable|set-interval <seconds>|restart_timer|get-current|quit}"
            exit 1
            ;;
    esac
  '';

  hyprpaper-random-control-completion = pkgs.writeTextFile {
    name = "hyprpaper-random-control-completion";
    destination = "/share/bash-completion/completions/${cfg.scriptName}";
    text = ''
      _hyprpaper-random-control_completions() {
          local cur prev opts
          COMPREPLY=()
          cur="''${COMP_WORDS[COMP_CWORD]}"
          prev="''${COMP_WORDS[COMP_CWORD-1]}"
          opts="change change-category enable disable set-interval get-current quit"

          if [[ ''${COMP_CWORD} -eq 1 ]]; then
              COMPREPLY=( $(compgen -W "''${opts}" -- ''${cur}) )
              return 0
          fi

          case "''${prev}" in
              set-interval)
                  COMPREPLY=( $(compgen -W "60 <tel:300 600 1800> 3600" -- ''${cur}) )
                  return 0
                  ;;
          esac
      }

      complete -F _hyprpaper-random-control_completions ${cfg.scriptName}
    '';
  };
in {
  options.hyprpaper.random = {
    enable = lib.mkEnableOption "Enable random hyprpaper";

    scriptName = lib.mkOption {
      default = "hyprpaper-random-control";
      type = lib.types.nonEmptyStr;
    };

    interval = lib.mkOption {
      description = "Interval between automatic changes of wallpaper";
      default = 600;
      type = lib.types.int;
    };

    hyprland.enable = lib.mkEnableOption "Enable hyprland integration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      hyprpaper-random-control
      hyprpaper-random-control-completion
    ];

    # home.shellAliases = {
    #   hrc = "${hyprpaper-random-control}/bin/${cfg.scriptName}";
    # };

    wayland.windowManager.hyprland = lib.mkIf cfg.hyprland.enable {
      settings = {
        bind = [
          "$mainMod, W, submap, wallpaper"
        ];
      };
      submaps = {
        wallpaper = {
          settings = {
            bind = [
              "SHIFT, c, exec, ${hyprpaper-random-control}/bin/${cfg.scriptName} change-category"
              ", r, exec, ${hyprpaper-random-control}/bin/${cfg.scriptName} change"

              ", escape, submap, reset"
            ];
          };
        };
      };
    };

    waybar.wallpaper = {
      enable = true;
      settings."custom/wallpaper-category" = {
        exec = "basename $(${hyprpaper-random-control}/bin/${cfg.scriptName} get-current)";
        format = "Wallpaper: {}";
        interval = cfg.interval;
      };
    };

    systemd.user.services.hyprpaper-random = {
      Unit = {
        Description = "Hyprpaper Random Wallpaper";
        After = ["hyprpaper.service"];
        Requires = ["hyprpaper.service"];
      };
      Service = {
        ExecStart = "${hyprpaper-random}/bin/hyprpaper-random";
        Type = "simple";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };
  };
}
