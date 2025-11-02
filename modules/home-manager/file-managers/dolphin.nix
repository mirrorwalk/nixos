{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.fileManagers.dolphin;

  package = pkgs.kdePackages.dolphin;
in {
  options.fileManagers.dolphin = {
    enable = mkEnableOption "Enable dolphin file manager";
    defaultFileManager = mkEnableOption "Set dolphin as a default file manager";
  };

  config = mkIf cfg.enable {
    home.packages = [
      package
    ];

    systemConfig.default.fileManager = mkIf cfg.defaultFileManager {
      command = "${package}/bin/dolphin";
      desktopName = "org.kde.dolphin.desktop";
    };
  };
}
