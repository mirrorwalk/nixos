{config, lib, ...}: let
  cScheme = config.styleConfig.colorScheme;
in {
  programs.cava = lib.mkIf config.programs.cava.enable {
    settings = {
      color = {
        background = "'${cScheme.secondary}'";
        foreground = "'${cScheme.primary}'";
      };
    };
  };
}
