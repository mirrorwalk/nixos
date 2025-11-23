{
  config,
  lib,
  ...
}: {
  options.autoMounting = {
    enable = lib.mkEnableOption "enable usb utils";
  };

  config = lib.mkIf config.autoMounting.enable {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
    };
  };
}
