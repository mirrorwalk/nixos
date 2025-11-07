{
  lib,
  config,
  ...
}: {
  options.tor = {
    enable = lib.mkEnableOption "";
    snowflake.enable = lib.mkEnableOption "";
  };
  config = lib.mkIf config.tor.enable {
    services = {
      tor = {
        enable = true;
        openFirewall = true;
      };

      snowflake-proxy = lib.mkIf config.tor.snowflake.enable {
        enable = true;
      };
    };
  };
}
