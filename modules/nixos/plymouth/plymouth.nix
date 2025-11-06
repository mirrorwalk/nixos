{
  config,
  lib,
  ...
}: {
  options.plymouth = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf config.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "solar";
    };
  };
}
