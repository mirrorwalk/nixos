{
  config,
  lib,
  ...
}: {
  options.plymouth = {
    enable = lib.mkEnableOption "enable plymouth";
  };

  config = lib.mkIf config.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "solar";
    };
  };
}
