{
  pkgs,
  config,
  lib,
  ...
}: {
  options.browsers.brave.enable = lib.mkEnableOption "Enable brave browser";

  config = lib.mkIf config.browsers.brave.enable {
    home.packages = [
      pkgs.brave
    ];
  };
}
