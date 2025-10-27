{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ../../custom/tmux-startup/tmux-startup.nix
    inputs.tmuxWorkspace.default
  ];

  options.shells.tmux.enable = lib.mkEnableOption "Enable tmux";

  config = lib.mkIf config.shells.tmux.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      baseIndex = 1;
      keyMode = "vi";
      mouse = false;
      escapeTime = 0;
      terminal = "screen-256color";
      secureSocket = true;
      extraConfig = ''
        bind-key C-a send-prefix
        set-window-option -g mode-keys vi
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        set -g status-style 'bg=#000000 fg=#ffffff'
        set -g renumber-windows on
        bind-key q kill-window
        bind-key K kill-session
      '';
    };
  };
}
  

