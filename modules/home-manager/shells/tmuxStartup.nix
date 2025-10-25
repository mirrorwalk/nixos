{
  # pkgs,
  lib,
  config,
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
  tmux-startup = ''
    #!/usr/bin/env bash
      if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
          all_sessions=`tmux list-sessions 2>/dev/null | grep "^term-"`

          if [ -n "$all_sessions" ]; then
              highest_num=-1
              latest_unattached=""

              while IFS= read -r session_line; do
                  session_name=`echo "$session_line" | cut -d: -f1`
                  session_num=`echo "$session_name" | sed 's/term-//'`

                  if [ "$session_num" -gt "$highest_num" ]; then
                      highest_num="$session_num"
                  fi

                  if ! echo "$session_line" | grep -q "(attached)"; then
                      latest_unattached="$session_name"
                  fi
              done <<< "$all_sessions"

              if [ -n "$latest_unattached" ]; then
                  exec tmux attach-session -t "$latest_unattached"
              else
                  new_num=`expr $highest_num + 1`
                  exec tmux new-session -s "term-$new_num"
              fi
          else
              exec tmux new-session -s "term-0"
          fi
      fi
  '';
in {
  options = {
    shells.tmuxStartup.enable = lib.mkEnableOption "Enable tmux startup";
  };
  config = lib.mkIf config.shells.tmuxStartup.enable {
    programs.bash = lib.mkIf config.shells.bash.enable {
        initExtra = lib.mkAfter "${tmux-startup}";
    };
    programs.zsh = lib.mkIf config.shells.zsh.enable {
        initContent = lib.mkAfter "${tmux-startup}";
    };
  };
}
