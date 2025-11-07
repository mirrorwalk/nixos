{
  lib,
  config,
  pkgs,
  ...
}: let
  colors = config.styleConfig.colorScheme;
in {
  options.notif.mako = {
    enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.notif.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        background-color = "${colors.accent}";
        text-color = "${colors.primary}";
        border-color = "${colors.secondary}";
        default-timeout = 1000;
        ignore-timeout = false;
      };
    };

    systemConfig.defaults.notifications.command = "${pkgs.mako}/bin/mako";
  };
}
