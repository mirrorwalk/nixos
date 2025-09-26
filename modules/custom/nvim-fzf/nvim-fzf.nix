{ lib, pkgs, ...}:
{
  programs.zsh = lib.mkIf (lib.hasAttr "zsh" pkgs) {
    initContent = ''
      nvim-fzf-widget() {
          $HOME/.local/bin/nvim-fzf/nvim-fzf.sh
          zle reset-prompt
      }

      zle -N nvim-fzf-widget

      bindkey '^g' nvim-fzf-widget
    '';
  };

  programs.bash = lib.mkIf (lib.hasAttr "bash" pkgs) {
      initExtra = ''
        bind '"\C-g":"$(/home/brog/.local/bin/nvim-fzf/nvim-fzf.sh)\n"'
      '';
  };

  home.file = {
    ".config/nvim-fzf/config".text = ''
      [roots]
      $HOME/.config/nixos
      $HOME/.config
      $HOME/projects
      $HOME/notes
      $HOME/.local/bin

      [ignore]
      .git
      node_modules
      target
      .direnv
    '';
  };
}
