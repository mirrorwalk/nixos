{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hyprpaper.random;

  pipe = "/tmp/hyprpaper-random.pipe";
  wallpaperFolders = cfg.wallpaperFolders;
  initialFolder = lib.head wallpaperFolders;

  hyprpaper-random = pkgs.writeShellScriptBin "hyprpaper-random" ''
        #!/usr/bin/env bash
        PIPE=${pipe}
        ENABLED=true
        WALLPAPER_FOLDER="${initialFolder}"
        INTERVAL=${cfg.interval} # seconds

        # Create named pipe if it doesn't exist
        [[ -p "$PIPE" ]] || mkfifo "$PIPE"

        # Cleanup on exit
        trap "kill 0; rm -f $PIPE" EXIT

    change_wallpaper() {
        # Read current category index from state file
        STATE_FILE="$HOME/.cache/hyprpaper-category-index"
        FOLDERS=(${lib.concatMapStringsSep " " (f: ''"${f}"'') wallpaperFolders})

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
            hyprctl hyprpaper wallpaper "${cfg.monitor},$WALLPAPER" > /dev/null 2>&1
            hyprctl hyprpaper unload all > /dev/null 2>&1
        else
            echo "No wallpapers found in $WALLPAPER_FOLDER"
        fi
    }


        # Timer function running in background
        timer() {
            while true; do
                sleep "$INTERVAL"
                if [[ "$ENABLED" == true ]]; then
                    echo "Timer triggered wallpaper change"
                    change_wallpaper
                fi
            done
        }

        # Start timer in background
        timer &

        # Initial wallpaper change
        change_wallpaper

        # Command listener
        while true; do
            if read cmd args < "$PIPE"; then
                echo "Received command: $cmd $args"
                case "$cmd" in
                    change)
                        [[ "$ENABLED" == true ]] && change_wallpaper
                        ;;
                    enable)
                        ENABLED=true
                        echo "Enabled"
                        ;;
                    disable)
                        ENABLED=false
                        echo "Disabled"
                        ;;
                    set_folder)
                        WALLPAPER_FOLDER="$args"
                        echo "Folder set to: $WALLPAPER_FOLDER"
                        [[ "$ENABLED" == true ]] && change_wallpaper
                        ;;
                    set_interval)
                        INTERVAL="$args"
                        echo "Interval set to: $INTERVAL"
                        ;;
                    quit)
                        exit 0
                        ;;
                esac
            fi
        done
  '';

  hyprpaper-random-control = pkgs.writeShellScriptBin "hyprpaper-random-control" ''
    #!/usr/bin/env bash
    PIPE=${pipe}
    STATE_FILE="$HOME/.cache/hyprpaper-category-index"
    FOLDERS=(${lib.concatMapStringsSep " " (f: ''"${f}"'') wallpaperFolders})

    if [[ ! -p "$PIPE" ]]; then
        echo "Error: Daemon not running (pipe not found at $PIPE)"
        exit 1
    fi

    change_category() {
        if [[ ''${#FOLDERS[@]} -eq 0 ]]; then
            echo "Error: No wallpaper folders configured"
            exit 1
        fi

        # Read current index, default to 0
        CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

        # Calculate next index (wrap around)
        NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ''${#FOLDERS[@]} ))

        # Save new index
        mkdir -p "$(dirname "$STATE_FILE")"
        echo "$NEXT_INDEX" > "$STATE_FILE"

        # Get the new folder path
        NEW_FOLDER="''${FOLDERS[$NEXT_INDEX]}"

        echo "Switching to category $((NEXT_INDEX + 1))/''${#FOLDERS[@]}: $NEW_FOLDER"

        # Send command to daemon
        echo "set_folder $NEW_FOLDER" > "$PIPE"
    }

    case "$1" in
        change-category)
            change_category
            ;;
        change|enable|disable|quit)
            echo "$1" > "$PIPE"
            ;;
        set_interval)
            echo "set_interval $2" > "$PIPE"
            ;;
        get-current)
            CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
            echo "''${FOLDERS[$CURRENT_INDEX]}"
            ;;
        *)
            echo "Usage: $0 {change|change-category|enable|disable|set_interval <seconds>|get-current|quit}"
            exit 1
            ;;
    esac
  '';
in {
  options.hyprpaper.random = {
    enable = lib.mkEnableOption "Enable random hyprpaper";
    monitor = lib.mkOption {
      default = "DP-1";
      type = lib.types.nonEmptyStr;
    };

    wallpaperFolders = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["/home/brog/Pictures/Wallpapers"];
      description = "List of wallpaper folder paths to cycle through";
    };

    interval = lib.mkOption {
      description = "Interval between automatic changes of wallpaper";
      default = "300";
      type = lib.types.nonEmptyStr;
    };

    hyprland = {
      exec = lib.mkEnableOption "Put it into exec-once in hyprland config";
      integration = lib.mkEnableOption "Integrate with hyprland and put usefull shortcuts";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      hyprpaper-random-control
    ];

    home.shellAliases = {
      hrc = "hyprpaper-random-control";
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = lib.mkIf cfg.hyprland.exec [
          "${hyprpaper-random}/bin/hyprpaper-random"
        ];
        bind = lib.mkIf cfg.hyprland.integration [
          "$mainMod, W, submap, wallpaper"
        ];
      };
      submaps = lib.mkIf cfg.hyprland.integration {
        wallpaper = {
          settings = {
            bind = [
              "SHIFT, c, exec, ${hyprpaper-random-control}/bin/hyprpaper-random-control change-category"
              ", r, exec, ${hyprpaper-random-control}/bin/hyprpaper-random-control change"

              ", escape, submap, reset"
            ];
          };
        };
      };
    };
  };
}
