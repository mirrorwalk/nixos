{
  config,
  lib,
  pkgs,
  ...
}: {
  options.autousb = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf config.autousb.enable {
    services = {
        udisks2.enable = true;
        gvfs.enable = true;
    };

    environment.systemPackages = with pkgs; [
      usbutils
    ];
  };
}
