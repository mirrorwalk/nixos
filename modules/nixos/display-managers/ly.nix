{
  config,
  lib,
  ...
}: let
  cfg = config.displayManager.ly;
in {
  options.displayManager.ly = {
    enable = lib.mkEnableOption "Enable ly display manager";
    animate = {
      enable = lib.mkEnableOption "Enable animation";
      animation = lib.mkOption {
        type = lib.types.enum [
          "none"
          "doom"
          "matrix"
          "colormix"
          "gameoflife"
        ];

        default = "matrix";
        description = "Which animation";
      };
    };
  };

  config.services.displayManager.ly = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      animate = cfg.animate.enable;
      animation = cfg.animate.animation;
      bigclock = true;
      hide_borders = true;
      hide_f1_commands = true;
      background_color = "colorcode";
    };
  };
}
