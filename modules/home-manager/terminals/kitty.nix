{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminals.kitty;
in {
  options.terminals.kitty = {
    enable = lib.mkEnableOption "Enable kitty shell";
    defaultTerminal = lib.mkEnableOption "Set kitty as default terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };

    systemConfig.default.terminal = lib.mkIf cfg.defaultTerminal {
      package = pkgs.kitty;
      command = "${pkgs.kitty}/bin/kitty";
    };
  };
}
