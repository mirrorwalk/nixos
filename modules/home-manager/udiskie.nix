{
  config,
  lib,
  ...
}: {
  options.udiskie.enable = lib.mkEnableOption "";
  config = lib.mkIf config.udiskie.enable {
    services.udiskie = {
      enable = true;
      settings = {
        device_config = [
          {
            id_type = "crypto_LUKS";
            automount = false;
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "systemctl --user restart udiskie"
        ];
      };
    };

    # systemd.user.services.udiskie = {
    #   Install.WantedBy = ["hyprland-session.target"];
    #   Unit = {
    #       ConditionEnvironment="WAYLAND_DISPLAY";
    #   };
    # };
  };
}
