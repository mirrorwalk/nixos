{
  inputs,
  pkgs,
  ...
}: {
  home.file.".local/bin/hyprpaper-random-wallpaper.sh".source = let
    script = pkgs.writeShellScriptBin "hyprpaper-random-wallpaper.sh" ''
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

      while true; do
          RANDOM_IMAGE=$(fd . "$WALLPAPER_DIR" --type=file | shuf -n 1)
          hyprctl hyprpaper preload "$RANDOM_IMAGE"
          hyprctl hyprpaper wallpaper DP-1,"$RANDOM_IMAGE"
          sleep 1
          hyprctl hyprpaper unload unused
          sleep 300
      done
    '';
  in "${script}/bin/hyprpaper-random-wallpaper.sh";
}
