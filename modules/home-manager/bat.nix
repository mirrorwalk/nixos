{
  pkgs,
  lib,
  config,
  ...
}: {
  options.shells.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.shells.bat.enable {
    home.shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
    };

    programs.bat = {
      enable = true;
    };

    home.sessionVariables = lib.mkDefault {
      PAGER = "bat";
    };
  };
}
