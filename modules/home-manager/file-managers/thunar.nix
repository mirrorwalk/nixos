{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.fileManagers.thunar;

  package = pkgs.xfce.thunar;
in {
  options.fileManagers.thunar = {
    enable = mkEnableOption "Enable thunar file manager";
    defaultFileManager = mkEnableOption "Set thunar as a default file manager";
  };

  config = mkIf cfg.enable {
    home.packages = [
      package
    ];

    systemConfig.default.fileManager = mkIf cfg.defaultFileManager {
      command = "${package}/bin/thunar";
      desktopName = "thunar.desktop";
    };
  };
}
