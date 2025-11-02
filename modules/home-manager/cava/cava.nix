{config, lib, ...}: let
  cScheme = config.styleConfig.colorScheme;
in {
    options.cava.enable = lib.mkEnableOption "Enable cava";

  config = lib.mkIf config.cava.enable {
    programs.cava = {
      enable = true;
      settings = {
        color = {
          background = "'${cScheme.secondary}'";
          foreground = "'${cScheme.primary}'";
        };
      };
    };
  };
}
