{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.music;
  ncspot = "${pkgs.ncspot}/bin/ncspot";
  tmux = "${pkgs.tmux}/bin/tmux";

  musicLauncher = pkgs.writeShellScriptBin "music" ''
    if [ -v TMUX ]; then
        if ${tmux} has-session -t music 2>/dev/null; then
            ${tmux} switch-client -t music
        else
            ${tmux} new-session -d -s music '${ncspot}'
            ${tmux} switch-client -t music
        fi
    else
        ${tmux} new-session -A -s music '${ncspot}'
    fi
  '';
in {
  options.music = {
    enable = lib.mkEnableOption "Enable music";
  };

  config = lib.mkIf cfg.enable {
    programs.ncspot = {
      enable = true;

      settings = {
          gapless = true;
          use_nerdfont = true;
          hide_display_names = true;
      };
    };

    home.shellAliases = {
      music = "${musicLauncher}/bin/music";
    };
  };
}
