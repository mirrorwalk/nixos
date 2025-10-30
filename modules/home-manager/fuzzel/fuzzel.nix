{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.fuzzel;
in {
  options.fuzzel = {
    width = mkOption {
      type = types.int;
      default = 50;
    };

    horizontalPad = mkOption {
      type = types.int;
      default = 20;
    };

    verticalPad = mkOption {
      type = types.int;
      default = 8;
    };

    innerPad = mkOption {
      type = types.int;
      default = 8;
    };
  };

  config = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "foot";
          layer = "overlay";
          exit-on-keyboard-focus-loss = "yes";
          width = cfg.width;
          horizontal-pad = cfg.horizontalPad;
          vertical-pad = cfg.verticalPad;
          inner-pad = cfg.innerPad;
          icons-enabled = "yes";
          show-actions = "yes";
        };

        colors = let
          clrs = config.styleConfig.colorScheme;
        in {
          background = "${clrs.primary}ff";
          text = "${clrs.secondary}ff";
          match = "${clrs.accent}ff";
          selection = "${clrs.accent}ff";
          selection-text = "${clrs.secondary}ff";
          selection-match = "${clrs.primary}ff";

          # background = "${clrs.background}ff";
          # text = "${clrs.text}ff";
          # match = "${clrs.accent}ff";
          # selection = "${clrs.primary}ff";
          # selection-text = "${clrs.text}ff";
          # # selection-match = "${clrs.accent}ff";
        };

        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    };
  };
}
# options = {
#   colorScheme = {
#     primary = lib.mkOption {
#       type = lib.types.str;
#       description = "Primary color in the color scheme";
#       default = "#502380"; # Tekhelet
#     };
#     secondary = lib.mkOption {
#       type = lib.types.str;
#       description = "Secondary color in the color scheme";
#       default = "#ffffff";
#     };
#     accent = lib.mkOption {
#       type = lib.types.str;
#       description = "Accent color in the color scheme";
#       default = "#893BFF";
#     };
#     background = lib.mkOption {
#       type = lib.types.str;
#       description = "Background color in the color scheme";
#       default = "#000000";
#     };
#     text = lib.mkOption {
#       type = lib.types.str;
#       description = "Background color in the color scheme";
#       default = "#ffffff";
#     };
#   };
# };

