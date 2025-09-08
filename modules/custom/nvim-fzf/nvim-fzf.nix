{
  programs.zsh.initContent = ''
    nvim-fzf-widget() {
        $HOME/.local/bin/nvim-fzf/nvim-fzf.sh
        zle reset-prompt
    }

    zle -N nvim-fzf-widget

    bindkey '^g' nvim-fzf-widget
  '';

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
