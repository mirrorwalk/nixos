{pkgs, ...}: {
  imports = [
    ../../custom/hyprpaper/hyprpaper.nix
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "foot";
        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";
        width = 50;
        horizontal-pad = 20;
        vertical-pad = 8;
        inner-pad = 8;
        icons-enabled = "yes";
        show-actions = "yes";
      };

      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "f38ba8ff";
        border = "b4befeff";
      };

      border = {
        width = 2;
        radius = 8;
      };

      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "${pkgs.ghostty}/bin/ghostty";
      "$fileManager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      "$menu" = "${pkgs.fuzzel}/bin/fuzzel";
      "$webBrowser" = "${pkgs.mullvad-browser}/bin/mullvad-browser";
      "$mainMod" = "SUPER";

      monitor = [
        "DP-1, 2560x1440@120.00, 1920x0, 1"
        "HDMI-A-1, 1920x1200@59.95, 0x0, 1"
      ];

      "exec-once" = [
        "systemctl --user restart waybar hyprpaper"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];

      general = {
        gaps_in = 8;
        gaps_out = 15;
        border_size = 3;
        "col.active_border" = "rgba(00ffddff) rgba(ff0080ff) rgba(ffff00ff) 45deg";
        "col.inactive_border" = "rgba(0d1117aa) rgba(1a1a2eff) 45deg";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      animations = {
        enabled = false;
      };

      decoration = {
        rounding = 12;
        active_opacity = 0.95;
        inactive_opacity = 0.85;

        shadow = {
          enabled = true;
          range = 8;
          render_power = 3;
          color = "rgba(00ddffaa)";
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          vibrancy = 0.3;
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
        # "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, Space, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod ALT, J, togglesplit,"
        "$mainMod, F, fullscreen, 1"
        "$mainMod SHIFT, F, fullscreen, 0"
        "$mainMod, B, exec, $webBrowser"
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
        "$mainMod, S, togglespecialworkspace, over"
        "$mainMod SHIFT, S, movetoworkspace, special:over"
        "$mainMod, M, togglespecialworkspace, music"
        "$mainMod SHIFT, M, movetoworkspace, special:music"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, W, submap, wallpaper"

        ", XF86PowerOff, exec, ~/.local/bin/shutdown-menu.sh"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "opacity 1.0, class:^(steam|Steam)$"
        "float,class:^(Tor Browser)$"
        "float,fullscreen:0,fullscreenrequest:0,class:Mullvad\ Browser"
        # "float,fullscreen:0,fullscreenrequest:0,noinitialfocus,initialClass:^(Mullvad Browser)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "move 75% 75%, title:^(Picture-in-Picture)$"
      ];
    };
    submaps = {
      wallpaper = {
        settings = {
          bind = [
            "SHIFT, c, exec, ~/.local/bin/random-wallpaper/hyprpaper/hyprpaper-category-override.sh"
            ", c, exec, ~/.local/bin/random-wallpaper/hyprpaper/hyprpaper-choose-wallpaper.sh"
            ", r, exec, systemctl --user restart hyprpaper-random.service"

            ", escape, submap, reset"
          ];
        };
      };
    };
  };
}
