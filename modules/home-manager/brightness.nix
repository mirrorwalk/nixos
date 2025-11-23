{
  lib,
  config,
  ...
}: let
  cfg = config.systemConfig.defaults.brightness;
in {
  config = lib.mkIf config.systemConfig.defaults.brightness.enable {
    wayland.windowManager.hyprland.settings.bind = [
      ", XF86MonBrightnessUp, exec, ${cfg.command.increase}"
      ", XF86MonBrightnessDown, exec, ${cfg.command.decrease}"
    ];
  };
}
