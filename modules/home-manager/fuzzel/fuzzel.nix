{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.runners.fuzzel;

  fuzzelWrap =
    (inputs.wrappers.wrapperModules.fuzzel.apply {
      inherit pkgs;
      settings = {
        main = {
          terminal = "${config.systemConfig.defaults.terminal.command} -e";
          layer = "overlay";
          exit-on-keyboard-focus-loss = "yes";
          width = cfg.width;
          horizontal-pad = cfg.horizontalPad;
          vertical-pad = cfg.verticalPad;
          inner-pad = cfg.innerPad;
          icons-enabled = "yes";

          show-actions =
            if cfg.showActions
            then "yes"
            else "no";

          dpi-aware = cfg.dpiAware;
        };

        colors = let
          clrs = config.styleConfig.colorScheme;
        in {
          background = "${clrs.primary}ff";
          text = "${clrs.secondary}ff";
          match = "${clrs.accent}ff";
          selection = "${clrs.accent}ff";
          selection-text = "${clrs.secondary}ff";
          selection-match = "${clrs.primary}ff";
        };

        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    }).wrapper;
in {
  options.runners.fuzzel = {
    enable = lib.mkEnableOption "Enable fuzzel";

    width = mkOption {
      type = types.int;
      default = 30;
    };

    horizontalPad = mkOption {
      type = types.int;
      default = 40;
    };

    verticalPad = mkOption {
      type = types.int;
      default = 8;
    };

    innerPad = mkOption {
      type = types.int;
      default = 0;
    };

    dpiAware = mkOption {
      type = types.str;
      default = "auto";
    };

    showActions = mkOption {
      type = types.bool;
      default = true;
    };

    defaultRunnerMenu = lib.mkEnableOption "fuzzel as default runner menu";
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      package = fuzzelWrap;
      # settings.colors.background = "000000ff";
    };
    # home.packages = [fuzzelWrap];

    systemConfig.defaults.runnerMenu.command = "${fuzzelWrap}/bin/fuzzel";
  };
}
