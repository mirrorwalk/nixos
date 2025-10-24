{
  config,
  pkgs,
  lib,
  ...
}: let
  tmux-startup =
    if config.bash.tmuxStartup.enable
    then ''
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
    ''
    else "";
in {
  options.bash.tmuxStartup.enable = lib.mkEnableOption "Enable tmux on startup";

  config = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        backup-message = "echo Backup: $(date '+%Y-%m-%d %H:%M:%S')";
        evi = "cd $HOME/.config/nvim && nvim .";
        la = "ls -AF --color=auto";
        tmuxs = "${pkgs.tmux}/bin/tmux new -s";
        tmuxa = "${pkgs.tmux}/bin/tmux attach-session -t nixos || ${pkgs.tmux}/bin/tmux switch-client -t ";
        nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell";
        nix-build = "${pkgs.nix-output-monitor}/bin/nom-build";
        nix = "${pkgs.nix-output-monitor}/bin/nom";
        cat = "${pkgs.bat}/bin/bat";
        rnos = "${pkgs.nh}/bin/nh os switch";
        nosr = "${pkgs.nh}/bin/nh os switch";
        nr = "${pkgs.nh}/bin/nh os switch";
        nt = "${pkgs.nh}/bin/nh os test";
        rn = "${pkgs.nh}/bin/nh os switch";
        ns = "${pkgs.nh}/bin/nh os switch";
        nos = "${pkgs.nh}/bin/nh os switch";
        nd = "${pkgs.nix-output-monitor}/bin/nom develop";
        ytdb = "${pkgs.yt-dlp}/bin/yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]'";
      };
      initExtra =
        ''
          if [ -f $HOME/.config/bash/paths.bash ]; then
              source $HOME/.config/bash/paths.bash
          fi

          enix() {
            if ! command -v tmux >/dev/null; then
                cd $HOME/.config/nixos
                nvim .
            elif tmux has-session -t nixos 2>/dev/null; then
                if [ -n "$TMUX" ]; then
                    tmux switch-client -t "nixos"
                else
                    tmux attach-session -t "nixos"
                fi
            else
                tmux new -d -s nixos -c ~/.config/nixos 'nvim .'
                if [ -n "$TMUX" ]; then
                    tmux switch-client -t "nixos"
                else
                    tmux attach-session -t "nixos"
                fi
            fi
          }

          fcd() {
              local dir
              dir=$(fd --type d 2>/dev/null | fzf)
              cd "$dir"
          }

          addpath() {
              if [ -d "$1" ]; then
                  # Convert to absolute path
                  local abs_path
                  abs_path=$(realpath "$1" 2>/dev/null || readlink -f "$1")
                  # Check if already in PATH
                  case ":$PATH:" in
                      *":$abs_path:"*)
                          echo "$abs_path is already in PATH"
                          return
                          ;;
                  esac
                  # Add to current session
                  export PATH="$abs_path:$PATH"
                  echo "Added $abs_path to PATH"
                  # Persist it in ~/.config/bash/paths.bash if not already there
                  local path_file="$HOME/.config/bash/paths.bash"
                  grep -qxF "export PATH=\"$abs_path:\$PATH\"" "$path_file" 2>/dev/null || \
                      echo "export PATH=\"$abs_path:\$PATH\"" >> "$path_file"
              else
                  echo "Directory $1 does not exist."
              fi
          }
          listpaths() {
              echo $PATH | tr ':' '\n'
          }
          nvimcd() {
              if [ -d "$1" ]; then
                  cd "$1" || return
                  nvim .
              else
                  nvim "$@"
              fi
          }

          git_branch() {
              git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/(&)/'
          }

          nix_indicator() {
              [[ -n "$IN_NIX_SHELL" ]] && printf '\e[38;5;15m❄\e[38;5;51m '
          }

          PS1='\[\e[38;5;51m\][\[\e[0m\]$(nix_indicator)\[\e[38;5;226m\]\u\[\e[38;5;40m\]@\[\e[38;5;33m\]\h \[\e[38;5;165m\]\w\[\e[38;5;51m\]]\[\e[38;5;196m\]$(git_branch)\[\e[38;5;51m\]$(if [ \j -gt 0 ]; then echo "(\j)"; fi)\[\e[0m\]$ '

          eval "$(direnv hook bash)"
          source <(jj util completion bash)
        ''
        + tmux-startup;
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
