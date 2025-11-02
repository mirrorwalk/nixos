{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.styleConfig.colorScheme = {
    primary = mkOption {
      type = types.str;
      description = "Primary color in the color scheme";
      default = "#780606";
    };

    secondary = mkOption {
      type = types.str;
      description = "Secondary color in the color scheme";
      default = "#000000";
    };

    accent = mkOption {
      type = types.str;
      description = "Accent color in the color scheme";
      default = "#ffffff";
    };
  };
}
