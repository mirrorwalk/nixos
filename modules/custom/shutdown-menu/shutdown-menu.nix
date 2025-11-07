{
  pkgs,
  lib,
  config,
  ...
}: {
  options.shutdownMenu = {
    enable = lib.mkEnableOption "Enable shutdown script";
  };

  config = let
    shutdown-script = pkgs.writeShellScriptBin "shutdown-script" ''
      #!/usr/bin/env bash

      # Power menu options
      options="⏻ Shutdown\n⭮ Reboot\n⏾ Suspend\n⏼ Hibernate\n"

      # Show menu and get selection
      selected=$(echo -e "$options" | fuzzel --dmenu --prompt="Power: " --width=20)

      # Execute based on selection
      case "$selected" in
          "⏻ Shutdown")
              systemctl poweroff
              ;;
          "⭮ Reboot")
              systemctl reboot
              ;;
          "⏾ Suspend")
              systemctl suspend
              ;;
          "⏼ Hibernate")
              systemctl hibernate
              ;;
          *)
              exit 0
              ;;
      esac
    '';
  in {
    wayland.windowManager.hyprland.settings.bind = lib.mkIf config.shutdownMenu.enable [
      ", XF86PowerOff, exec, ${shutdown-script}/bin/shutdown-script"
    ];
  };
}
