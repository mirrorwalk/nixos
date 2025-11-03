{
  config,
  lib,
  ...
}: let
  cfg = config.keyring.gnome;
in {
  options.keyring.gnome = {
    enable = lib.mkEnableOption "Enable gnome keyring";

    ly = lib.mkOption {
      type = lib.types.bool;
      description = "Enable ly integration";
      default = config.displayManager.ly.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services.ly.enableGnomeKeyring = cfg.ly;
  };
}
