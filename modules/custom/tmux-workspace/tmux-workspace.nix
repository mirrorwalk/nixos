{
  lib,
  config,
  ...
}: {
  options.tmux-workspace.enable = lib.mkEnableOption "enable tmux-workspace";

  config = lib.mkIf config.tmux-workspace.enable {
    programs.zsh = lib.mkIf config.shells.zsh.enable {
      initContent = ''
        bindkey -s '^x' "tmux-workspace\n"
      '';
    };

    programs.bash = lib.mkIf config.shells.bash.enable {
      initExtra = ''
        bind '"\C-x":"/home/brog/.local/bin/tmux-workspace/tmux-workspace\n"'
      '';
    };

    home.file = {
      ".config/tmux-workspace/config.sh".text = ''
        #!/bin/bash

                declare -A ROOT_FOLDERS
                ROOT_FOLDERS["$HOME/projects"]="1:1"
                ROOT_FOLDERS["$HOME/projects/zig"]="1:1"
                ROOT_FOLDERS["$HOME/projects/svelte"]="1:1"
                ROOT_FOLDERS["$HOME/projects/python"]="1:1"
                ROOT_FOLDERS["$HOME/.config"]="1:1"
                ROOT_FOLDERS["$HOME/.config/nvim"]="0:1"

                declare -A CUSTOM_WINDOWS
                CUSTOM_WINDOWS["$HOME/projects/passim"]="code:terminal"
                CUSTOM_WINDOWS["$HOME/projects/zig/taskrhythm"]="code:terminal"
                CUSTOM_WINDOWS["$HOME/projects/svelte/TaskFlow"]="code:server"
                CUSTOM_WINDOWS["$HOME/projects/TaterRogue"]="code:terminal"
      '';
    };
  };
}
