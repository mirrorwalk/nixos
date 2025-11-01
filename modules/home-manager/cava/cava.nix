{config, ...}: let
  cScheme = config.styleConfig.colorScheme;
in{
  programs.cava = {
    enable = true;
    settings = {
      color = {
        background = "'${cScheme.secondary}'";
        foreground = "'${cScheme.primary}'";
      };
    };
  };
}
