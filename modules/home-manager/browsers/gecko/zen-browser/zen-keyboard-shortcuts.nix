{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.browsers.zen-browser;

  keybindSubmodule = lib.types.submodule {
    options = {
      key = lib.mkOption {
        type = lib.types.str;
      };

      modifiers = {
        control = lib.mkEnableOption "";
        alt = lib.mkEnableOption "";
        shift = lib.mkEnableOption "";
        meta = lib.mkEnableOption "";
        accel = lib.mkEnableOption "";
      };
    };
  };

  # defaultShortcuts = lib.trivial.importJSON ./zen.json;
  defaultShortcuts = lib.trivial.importJSON ./zen-keyboard-shortcuts.json;

  hardModifiedShortcuts = map (shrt:
    if shrt.id == "zen-compact-mode-toggle"
    then shrt // {key = "b";}
    else shrt)
  defaultShortcuts.shortcuts;

  modifiedShortcuts = {
    shortcuts = map (shrt:
      if shrt.id != null && builtins.hasAttr shrt.id cfg.shortcuts.set
      then shrt // cfg.shortcuts.set.${shrt.id}
      else shrt)
    defaultShortcuts.shortcuts;
  };
in {
  options.browsers.zen-browser = {
    shortcuts = {
      enable = lib.mkEnableOption "";
      set = lib.mkOption {
        type = lib.types.attrsOf keybindSubmodule;
      };
    };
  };

  config = lib.mkIf cfg.shortcuts.enable {
    browsers.zen-browser.shortcuts.set = {
      "zen-workspace-switch-1" = {
        key = "1";
        modifiers = {
          alt = true;
        };
      };
      "zen-workspace-switch-2" = {
        key = "2";
        modifiers = {
          alt = true;
        };
      };
      "zen-workspace-switch-3" = {
        key = "3";
        modifiers = {
          alt = true;
        };
      };
      "zen-workspace-switch-4" = {
        key = "4";
        modifiers = {
          alt = true;
        };
      };
      "zen-workspace-switch-5" = {
        key = "5";
        modifiers = {
          alt = true;
        };
      };
      "zen-workspace-switch-6" = {
        key = "6";
        modifiers = {
          alt = true;
        };
      };

      "key_selectTab1" = {
        key = "1";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab2" = {
        key = "2";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab3" = {
        key = "3";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab4" = {
        key = "4";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab5" = {
        key = "5";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab6" = {
        key = "6";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab7" = {
        key = "7";
        modifiers = {
          accel = true;
        };
      };
      "key_selectTab8" = {
        key = "8";
        modifiers = {
          accel = true;
        };
      };
      "key_selectLastTab" = {
        key = "9";
        modifiers = {
          accel = true;
        };
      };
    };

    home.file.".zen/default/zen-keyboard-shortcuts.json" = {
      text = builtins.toJSON modifiedShortcuts;
      force = true;
    };
  };
}
