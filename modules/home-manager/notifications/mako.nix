{
  lib,
  config,
  pkgs,
  ...
}: {
  options.notif.mako = {
    enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.notif.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        background-color = "#000000";
        border-color = "#FFFFFF";
        default-timeout = 1000;
        ignore-timeout = false;
      };
    };

    systemConfig.defaults.notifications.command = "${pkgs.mako}/bin/mako";
  };
}
