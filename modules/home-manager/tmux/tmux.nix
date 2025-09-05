{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";
    mouse = false;
    escapeTime = 0;
    extraConfig = ''
      bind-key C-a send-prefix
      set -g status-style 'bg=#000000 fg=#ffffff'
      set -g renumber-windows on
      bind-key q kill-window
      bind-key K kill-session
    '';
  };
}
