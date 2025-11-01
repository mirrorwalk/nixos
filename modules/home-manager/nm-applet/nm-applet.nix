{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.nmApplet = {
    enable = mkEnableOption "Enable nm applet";
    integration.hyprland = mkEnableOption "Launch nm applet in hyprland";
  };

  config = lib.mkIf config.nmApplet.enable {
    wayland.windowManager.hyprland = lib.mkIf config.nmApplet.integration.hyprland {
      settings = {
        exec-once = [
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
        ];
      };
    };
  };
}
