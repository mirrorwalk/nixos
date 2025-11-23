{
  lib,
  config,
  ...
}: let
  cfg = config.hypr.hyprlock;
  hyprland = cfg.hyprland;
in {
  options.hypr.hyprlock = {
    enable = lib.mkEnableOption "Enable hyprlock";
    hyprland = {
      enable = lib.mkEnableOption "Enable hyprland bind";
      keybind = lib.mkOption {
        description = "The keybind to be used by hyprland";
        type = lib.types.str;
        default = "$mainMod CTRL, L";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = false;
          hide_cursor = true;
          grace = 0;
          no_fade_in = false;
        };

        background = [
          {
            color = "rgba(0, 0, 0, 1.0)";
          }
        ];

        input-field = [
          {
            size = "300, 50";
            position = "0, -20";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(ff0033)";
            inner_color = "rgb(0d1117)";
            outer_color = "rgb(ff0033)";
            outline_thickness = 2;
            placeholder_text = "<i>Enter Password...</i>";
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 90;
            font_family = "sans-serif";
            position = "0, 200";
            halign = "center";
            valign = "center";
            color = "rgb(ff0033)";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"<span>$(date '+%A, %d %m %Y')</span>\"";
            font_size = 24;
            font_family = "sans-serif";
            position = "0, 100";
            halign = "center";
            valign = "center";
            color = "rgb(990000)";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = lib.mkIf hyprland.enable {
      settings = {
        bind = [
          "${hyprland.keybind + ", exec, hyprlock"}"
        ];
      };
    };
  };
}
