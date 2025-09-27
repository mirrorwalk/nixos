{
  lib,
  pkgs,
  config,
  ...
}: {
  # options = {
  #   tmux-workspace.enable = lib.mkEnableOption "enables tmux-workspace";
  #   tmux-workspace.bash = lib.mkEnableOption "enables tmux-workspace keybind for bash";
  #   tmux-workspace.zsh = lib.mkEnableOption "enables tmux-workspace keybind for zsh";
  # };

  # programs.zsh = lib.mkIf config.tmux-workspace.zsh {
  #   initContent = ''
  #     bindkey -s '^x' "tmux-workspace\n"
  #   '';
  # };
  programs.zsh = lib.mkIf (lib.hasAttr "zsh" pkgs) {
    initContent = ''
      bindkey -s '^x' "tmux-workspace\n"
    '';
  };

  programs.bash = lib.mkIf (lib.hasAttr "bash" pkgs) {
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
