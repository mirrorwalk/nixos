{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "foot";
        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";
        width = 50;
        horizontal-pad = 20;
        vertical-pad = 8;
        inner-pad = 8;
        icons-enabled = "yes";
        show-actions = "yes";
      };

      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "f38ba8ff";
        border = "b4befeff";
      };

      border = {
        width = 2;
        radius = 8;
      };

      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}
