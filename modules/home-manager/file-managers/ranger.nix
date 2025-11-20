{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.fileManagers.ranger;

  term = config.systemConfig.defaults.terminal.command;

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
      };
    };

    systemConfig.defaults.fileManager = mkIf cfg.defaultFileManager {
      command = "${term} -e ${package}/bin/ranger";
      desktopName = "ranger.desktop";
    };
  };
}
