{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.fileManagers.ranger;

  package = pkgs.ranger;
in {
  options.fileManagers.ranger = {
    enable = mkEnableOption "Enable ranger file manager";
    defaultFileManager = mkEnableOption "Set ranger as a default file manager";
  };

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;

      settings = {
        preview_images = true;
        preview_images_method = "kitty";
        preview_imagesize = 100;
      };
    };

    systemConfig.default.fileManager = mkIf cfg.defaultFileManager {
      command = "${package}/bin/ranger";
      desktopName = "ranger.desktop";
    };
  };
}
