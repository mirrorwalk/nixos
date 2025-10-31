{
  config,
  lib,
  ...
}: {
  options = {
    shells.bash = {
      enable = lib.mkEnableOption "Enable bash";

      ps1 = lib.mkOption {
        type = lib.types.str;
        default = ''\[\e[38;5;51m\][\[\e[0m\]$(nix_indicator)\[\e[38;5;226m\]\u\[\e[38;5;40m\]@\[\e[38;5;33m\]\h \[\e[38;5;165m\]\w\[\e[38;5;51m\]]\[\e[38;5;196m\]$(git_branch)\[\e[38;5;51m\]$(if [ \j -gt 0 ]; then echo "(\j)"; fi)\[\e[0m\]$ '';
      };
    };
  };

  config = lib.mkIf config.shells.bash.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra =
        ''
          if [ -f $HOME/.config/bash/paths.bash ]; then
              source $HOME/.config/bash/paths.bash
          fi

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

          git_branch() {
              git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/(&)/'
          }

          nix_indicator() {
              [[ -n "$IN_NIX_SHELL" ]] && printf '\e[38;5;15m❄\e[38;5;51m '
          }

          PS1='${config.shells.bash.ps1}'

          eval "$(direnv hook bash)"
          source <(jj util completion bash)
        ''
        + config.shells.shFunctions;
    };

    programs.fzf.enableBashIntegration = true;
  };
}
