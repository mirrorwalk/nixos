{
  config,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Cyberpunk Scarlet Protocol";
      confirm-close-surface = false;
      font-family = "Orbitron Regular";
      font-size = 12;
      shell-integration-features = "cursor,sudo,no-title";
    };
    enableZshIntegration = lib.mkIf config.shells.zsh.enable true;
    enableBashIntegration = lib.mkIf config.shells.bash.enable true;
    installBatSyntax = lib.mkIf config.shells.bat.enable true;
    installVimSyntax = true;
  };
}
