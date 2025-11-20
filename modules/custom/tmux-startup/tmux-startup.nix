{
  lib,
  config,
  pkgs,
  ...
}: let
  # tmux-startup = pkgs.writeShellScriptBin "tmux-startup" ''
  #   #!/usr/bin/env bash
  #     if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  #         all_sessions=`tmux list-sessions 2>/dev/null | grep "^term-"`
  #
  #         if [ -n "$all_sessions" ]; then
  #             highest_num=-1
  #             latest_unattached=""
  #
  #             while IFS= read -r session_line; do
  #                 session_name=`echo "$session_line" | cut -d: -f1`
  #                 session_num=`echo "$session_name" | sed 's/term-//'`
  #
  #                 if [ "$session_num" -gt "$highest_num" ]; then
  #                     highest_num="$session_num"
  #                 fi
  #
  #                 if ! echo "$session_line" | grep -q "(attached)"; then
  #                     latest_unattached="$session_name"
  #                 fi
  #             done <<< "$all_sessions"
  #
  #             if [ -n "$latest_unattached" ]; then
  #                 exec tmux attach-session -t "$latest_unattached"
  #             else
  #                 new_num=`expr $highest_num + 1`
  #                 exec tmux new-session -s "term-$new_num"
  #             fi
  #         else
  #             exec tmux new-session -s "term-0"
  #         fi
  #     fi
  # '';
  tmux-startup = pkgs.writeShellScriptBin "tmux-startup" ''
    #!/usr/bin/env bash

    # Get all term-* sessions
    all_sessions=$(tmux list-sessions 2>/dev/null | grep "^term-" || true)

    if [ -n "$all_sessions" ]; then
        highest_num=-1
        latest_unattached=""

        while IFS= read -r session_line; do
            session_name=$(echo "$session_line" | cut -d: -f1)
            session_num=$(echo "$session_name" | sed 's/term-//')

            if [ "$session_num" -gt "$highest_num" ]; then
                highest_num="$session_num"
            fi

            if ! echo "$session_line" | grep -q "(attached)"; then
                latest_unattached="$session_name"
            fi
        done <<< "$all_sessions"

        if [ -n "$latest_unattached" ]; then
            # If inside tmux, switch to it; if outside, attach
            if [ -n "$TMUX" ]; then
                tmux switch-client -t "$latest_unattached"
            else
                exec tmux attach-session -t "$latest_unattached"
            fi
        else
            new_num=$((highest_num + 1))
            if [ -n "$TMUX" ]; then
                tmux new-session -d -s "term-$new_num" \; switch-client -t "term-$new_num"
            else
                exec tmux new-session -s "term-$new_num"
            fi
        fi
    else
        if [ -n "$TMUX" ]; then
            tmux new-session -d -s "term-0" \; switch-client -t "term-0"
        else
            exec tmux new-session -s "term-0"
        fi
    fi
  '';

  cfg = config.shells.tmux.tmuxStartup;
  tsu = "${tmux-startup}/bin/tmux-startup";
in {
  options = {
    shells.tmux.tmuxStartup = {
      enable = lib.mkEnableOption "Enable tmux startup";
      ghosttyIntegration = lib.mkEnableOption "Enable ghostty integration";
      addToPackages = lib.mkEnableOption "Add tmux-startup to packages";
      aliasToTmux = lib.mkEnableOption "Realias tmux to tmux-startup";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.addToPackages [
      tmux-startup
    ];

    home.shellAliases = lib.mkIf cfg.aliasToTmux {
      tmux = tsu;
    };

    programs.tmux = {
        extraConfig = ''
            set -s command-alias[100] 'new=run-shell ${tsu}'
            bind-key N run-shell ${tsu}
        '';
    };

    programs.ghostty.settings.command = lib.mkIf cfg.ghosttyIntegration "${tsu}";
  };
}
