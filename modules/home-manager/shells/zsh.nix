{
  lib,
  config,
  ...
}: {
  options = {
    shells.zsh.enable = lib.mkEnableOption "Enable zsh";
  };
  config = lib.mkIf config.shells.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent =
        ''
          if [ -f $HOME/.config/zsh/paths.zsh ]; then
              source $HOME/.config/zsh/paths.zsh
          fi

          eval "$(direnv hook zsh)"
          source <(jj util completion zsh)
        ''
        + config.shells.shFunctions;
    };

    programs.fzf.enableZshIntegration = true;
  };
}
