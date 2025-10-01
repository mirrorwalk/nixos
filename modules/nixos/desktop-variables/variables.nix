{lib, ...}: {
  options = {
    colorScheme = {
      primary = lib.mkOption {
        type = lib.types.str;
        description = "Primary color in the color scheme";
        default = "#502380"; # Tekhelet
      };
      secondary = lib.mkOption {
        type = lib.types.str;
        description = "Secondary color in the color scheme";
        default = "#ffffff";
      };
      accent = lib.mkOption {
        type = lib.types.str;
        description = "Accent color in the color scheme";
        default = "#893BFF";
      };
      background = lib.mkOption {
        type = lib.types.str;
        description = "Background color in the color scheme";
        default = "#000000";
      };
      text = lib.mkOption {
        type = lib.types.str;
        description = "Background color in the color scheme";
        default = "#ffffff";
      };
    };
  };
}
