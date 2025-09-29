{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "$HOME/Pictures/Wallpapers/sfw/thumb-1920-1345286.png";
      wallpaper = "DP-1,$HOME/Pictures/Wallpapers/sfw/thumb-1920-1345286.png";
    };
  };

  systemd.user.services = {
    hyprpaper = {
      Unit = {
        ConditionPathExists = "/run/user/%U/wayland-1";
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    hyprpaper-random = {
      Unit = {
        Description = "hyprpaper random wallpaper background";
        After = ["hyprpaper.service"];
      };
      Service = {
        ExecStart = "%h/.local/bin/random-wallpaper/hyprpaper/hyprpaper-random-wallpaper.sh";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprpaper.service"];
      };
    };
  };
}
