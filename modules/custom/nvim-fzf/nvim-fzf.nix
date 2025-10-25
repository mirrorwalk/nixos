{
  lib,
  config,
  ...
}: {
  options.nvim-fzf.enable = lib.mkEnableOption "enable nvim-fzf";

  config = lib.mkIf config.nvim-fzf.enable {
    programs.zsh = lib.mkIf config.shells.zsh.enable {
      initContent = ''
        nvim-fzf-widget() {
            $HOME/.local/bin/nvim-fzf/nvim-fzf.sh
            zle reset-prompt
        }

        zle -N nvim-fzf-widget

        bindkey '^g' nvim-fzf-widget
      '';
    };

    programs.bash = lib.mkIf config.shells.bash.enable {
      initExtra = ''
        bind '"\C-g":"/home/brog/.local/bin/nvim-fzf/nvim-fzf.sh\n"'
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
  };
}
