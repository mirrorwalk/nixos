{
  pkgs,
  lib,
  config,
  ...
}: let
  defaults = config.systemConfig.defaults;
  anim = config.desktop.hyprland.animation;
  volumeBindsEnabled = config.desktop.hyprland.volumeBinds;
in {
  options.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland desktop environment";

    animation = {
        enable = lib.mkEnableOption "Enable animations";

      speed = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Animation speed multiplier (1ds = 100ms). Lower = faster, higher = slower.";
      };
    };

    volumeBinds = lib.mkEnableOption "Enable volume control binds";
  };

  config = lib.mkIf config.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$terminal" = defaults.terminal.command;
        "$fileManager" = defaults.fileManager.command;
        "$menu" = defaults.runnerMenu.command;
        "$webBrowser" = defaults.webBrowser.command;
        "$mainMod" = "SUPER";

        monitor =
          map (
            m: let
              resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = "${toString m.x}x${toString m.y}";
            in "${m.name},${
              if m.enabled
              then "${resolution},${position},${toString m.scale}"
              else "disabled"
            }"
          )
          (config.systemConfig.monitors);

        exec-once = [
          # "${defaults.fileManager.command} --daemon"
          "${pkgs.mako}/bin/mako"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        ];

        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          "col.active_border" = "rgba(ff0033ee) rgba(990000ee) rgba(330000ee) 45deg";
          "col.inactive_border" = "rgba(1a1a1aaa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        animations = {
          enabled = anim.enable;
          # workspace_wraparound = true;

          bezier = [
            "vampSlide, 0.13, 0.99, 0.29, 1.0"
            "bloodPulse, 0.87, 0, 0.13, 1"
          ];

          animation = [
            "windowsIn, 1, ${toString anim.speed}, vampSlide, slide"
            "windowsOut, 1, ${toString (anim.speed - 1)}, bloodPulse, slide"
            "windowsMove, 1, ${toString (anim.speed - 1)}, vampSlide, slide"
            "fadeIn, 1, ${toString (anim.speed + 2)}, vampSlide"
            "fadeOut, 1, ${toString anim.speed}, bloodPulse"
            "fadeSwitch, 1, ${toString anim.speed}, vampSlide"
            "fadeShadow, 1, ${toString anim.speed}, vampSlide"
            "fadeDim, 1, ${toString anim.speed}, vampSlide"
            "workspaces, 1, ${toString (anim.speed - 1)}, vampSlide, slidevert"
            "borderangle, 1, 100, bloodPulse, loop"
          ];
        };

        decoration = {
          rounding = 12;
          active_opacity = 0.95;
          inactive_opacity = 0.85;

          shadow = {
            enabled = true;
            range = 20;
            render_power = 3;
            color = "rgba(ff003355)";
          };

          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            vibrancy = 0.3;
            noise = 0.02;
            contrast = 1.1;
            brightness = 1.2;
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
          split_width_multiplier = 1.2;
        };

        master = {
          new_status = "master";
          new_on_top = true;
          mfact = 0.6;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = "rgba(0d1117ff)";
          vrr = 2;
          focus_on_activate = true;
          enable_swallow = true;
          swallow_regex = "^(kitty|alacritty|Alacritty)$";
          new_window_takes_over_fullscreen = 0;
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "caps:escape";
          kb_rules = "";
          follow_mouse = 1;
          mouse_refocus = false;
          numlock_by_default = true;
          sensitivity = 0.2;
        };

        bind = [
          "$mainMod, Return, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, Q, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, Space, exec, $menu"
          "$mainMod SHIFT, P, pseudo,"
          "$mainMod, P, pin,"
          "$mainMod ALT, J, togglesplit,"
          "$mainMod, F, fullscreen, 1"
          "$mainMod SHIFT, F, fullscreen, 0"
          "$mainMod, B, exec, $webBrowser"
          "$mainMod, Tab, cyclenext"
          "$mainMod SHIFT, Tab, cyclenext, tiled"
          "$mainMod ALT, Tab, cyclenext, floating"
          (builtins.trace "modularize this keybind" "$mainMod CTRL, L, exec, hyprlock")
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod ALT, E, togglespecialworkspace, editor"
          "$mainMod SHIFT, E, movetoworkspace, special:editor"
          "$mainMod, S, togglespecialworkspace, over"
          "$mainMod SHIFT, S, movetoworkspace, special:over"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ] ++ lib.optionals volumeBindsEnabled [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioRaiseVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrulev2 = builtins.trace "Modularize hyprland window rules" [
          "opacity 1.0, class:^(steam|Steam)$"
          "float,class:^(Tor Browser)$"
          "suppressevent fullscreen maximize fullscreenoutput,class:(Tor Browser)"
          "float,class:(Mullvad Browser)"
          "suppressevent fullscreen maximize fullscreenoutput,class:(Mullvad Browser)"
          "suppressevent fullscreen maximize fullscreenoutput,initialClass:(Godot)"
          "suppressevent fullscreen maximize fullscreenoutput,initialTitle:(Godot)"
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "move 75% 75%, title:^(Picture-in-Picture)$"
        ];
      };
    };
  };
}

