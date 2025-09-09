{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      enix = "cd $HOME/.config/nixos && nvim $HOME/.config/nixos";
      la = "ls -aF --color=auto";
      tmuxs = "tmux new -s";
      tmuxa = "tmux attach -t";
      # nix-shell = "nom-shell";
      nix-build = "nom-build";
    };
    initExtra = ''
      if [ -f $HOME/.config/bash/paths.bash ]; then
          source $HOME/.config/bash/paths.bash
      fi
      # Functions
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
      rebuild-nixos-no-git() {
          local prev_dir="$PWD"
          cd "$HOME/.config/nixos" || {
              echo "Could not find $HOME/.config/nixos"
              return 1
          }
          sudo nixos-rebuild switch --flake "$HOME/.config/nixos#desktop"
          cd "$prev_dir" || return
      }
      rebuild-nixos() {
          local prev_dir="$PWD"
          cd "$HOME/.config/nixos" || {
              echo "Could not find $HOME/.config/nixos"
              return 1
          }
          if [[ -z $(git status --porcelain) ]]; then
              echo "No configuration changes — skipping rebuild."
              return 0
          fi
          echo "Building new NixOS configuration (test build)..."
          if nixos-rebuild build --flake "$HOME/.config/nixos#desktop"; then
              echo "Build succeeded. Committing changes..."
              rm ./result
              git add .
              git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
              git push
              echo "Activating committed configuration..."
              sudo nixos-rebuild switch --flake "$HOME/.config/nixos#desktop"
              echo "Rebuild complete."
              cd "$prev_dir" || return
          else
              echo "Build failed — no commit made."
              return 1
          fi
          cd "$prev_dir" || return
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

# Function to show Nix shell indicator
      nix_indicator() {
          [[ -n "$IN_NIX_SHELL" ]] && printf '\e[38;5;15m❄\e[38;5;51m '
      }

# Set PS1 with proper color escapes and function calls
      PS1='\[\e[38;5;51m\][\[\e[0m\]$(nix_indicator)\[\e[38;5;226m\]\u\[\e[38;5;40m\]@\[\e[38;5;33m\]\h \[\e[38;5;165m\]\w\[\e[38;5;51m\]]\[\e[38;5;196m\]$(git_branch)\[\e[38;5;51m\]$(if [ \j -gt 0 ]; then echo "(\j)"; fi)\[\e[0m\]$ '

      eval "$(direnv hook bash)"
      source <(jj util completion bash)
      if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
          tmux attach-session -t default || tmux new-session -s default
      fi
    '';
  };
}
