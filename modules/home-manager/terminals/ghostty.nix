{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminals.ghostty;
in {
  options.terminals.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty shell";
    defaultTerminal = lib.mkEnableOption "Set ghostty as default terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Aura";
        confirm-close-surface = false;
        font-family = "Orbitron Regular";
        font-size = 12;
        shell-integration-features = "cursor,sudo,no-title";
      };

      enableZshIntegration = lib.mkIf config.shells.zsh.enable true;
      enableBashIntegration = lib.mkIf config.shells.bash.enable true;
      installBatSyntax = lib.mkIf config.shells.bat.enable true;
      installVimSyntax = lib.mkIf config.programs.neovim.enable true;
    };

    systemConfig.defaults.terminal = lib.mkIf cfg.defaultTerminal {
      package = pkgs.ghostty;
      command = "${pkgs.ghostty}/bin/ghostty";
    };
  };
}
