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
    ".local/bin/nvim-fzf".source = "./nvim-fzf";

    ".config/tmux-workspace/config.sh".text = ''
      #!/bin/bash

      declare -A ROOT_FOLDERS
      ROOT_FOLDERS["$HOME/projects"]="1:1"
      ROOT_FOLDERS["$HOME/projects/zig"]="1:1"
      ROOT_FOLDERS["$HOME/projects/svelte"]="1:1"
      ROOT_FOLDERS["$HOME/.config"]="1:1"
      ROOT_FOLDERS["$HOME/.config/nvim"]="0:1"

      declare -A CUSTOM_WINDOWS
      CUSTOM_WINDOWS["$HOME/projects/passim"]="code:terminal"
      CUSTOM_WINDOWS["$HOME/projects/zig/taskrhythm"]="code:terminal"
      CUSTOM_WINDOWS["$HOME/projects/svelte/TaskFlow"]="code:server"
      CUSTOM_WINDOWS["$HOME/projects/TaterRogue"]="code:terminal"
    '';
  };
}
