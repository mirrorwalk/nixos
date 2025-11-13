{
  programs.hyprlock = builtins.trace "modularize hyprlock and the hyplrand keybind" {
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
          path = "screenshot";
          blur_passes = 3;
          blur_size = 6;
          noise = 0.02;
          contrast = 1.1;
          brightness = 1.2;
          vibrancy = 0.3;
          vibrancy_darkness = 0.0;
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
          shadow_passes = 2;
          shadow_size = 20;
          shadow_color = "rgba(ff003355)";
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
          shadow_passes = 2;
          shadow_size = 20;
          shadow_color = "rgba(ff003355)";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date '+%A, %B %d')</span>\"";
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
}
