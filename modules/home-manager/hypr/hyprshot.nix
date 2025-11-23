{
  config,
  lib,
  ...
}: let
  cfg = config.hypr.hyprshot.enable;
in {
  options.hypr.hyprshot.enable = lib.mkEnableOption "Enable hyprshot";
  config = lib.mkIf cfg {
    programs.hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/Screenshots";
    };
  };
}
