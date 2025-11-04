{
  lib,
  config,
  ...
}: let
  cfg = config.browsers.zen-browser;

  defaultShortcuts = builtins.readFile ./zen-keyboard-shortcuts.json;
in {
  options.browsers.zen-browser = {
    shortcuts = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".zen/default/zen-keyboard-shortcuts.json" = {
      text = defaultShortcuts;
      enable = false;
    };

    browsers.zen-browser.shortcuts.shortcuts = {
      hey = "";
    };

    home.activation = builtins.trace "fuck you" {
      myActivationAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ln -s $VERBOSE_ARG \
            ${builtins.toPath ./link-me-directly} $HOME
      '';
    };
  };
}
