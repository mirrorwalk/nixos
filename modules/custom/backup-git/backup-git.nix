{
  pkgs,
  lib,
  config,
  ...
}: let
  # backup-git = pkgs.writeShellScriptBin "backup-git" ''
  #   ${builtins.readFile ./backup-git.sh}
  # '';
  backupFolders = config.backupGit.backupFolders;

  backup-git = pkgs.writeShellScriptBin "backup-git" ''
    #!/usr/bin/env bash

      AUTO_CONFIRM=false
      USE_NORMAL_TIME=false
      CUSTOM_PATHS=()

      while [[ $# -gt 0 ]]; do
          case $1 in
              -y)
                  AUTO_CONFIRM=true
                  ;;
              -d)
                  USE_NORMAL_TIME=true
                  ;;
              -h)
                  echo "Usage: $0 [-y] [-d] [path1] [path2] ..."
                  echo "  -y    Auto-confirm all prompts"
                  echo "  -d    Use normal date format (YYYY-MM-DD HH:MM:SS) instead of epoch time"
                  echo "  [path] Backup specified path(s) instead of default repos"
                  exit 0
                  ;;
              *)
                  CUSTOM_PATHS+=("$1")
                  ;;
          esac
          shift
      done

      if [ ''${#CUSTOM_PATHS[@]} -eq 0 ]; then
          REPOS=(
              "$HOME/.config/nvim"
              "$HOME/.config/nixos-private"
              "$HOME/.config/nixos"
              "$HOME/.config"
          )
          REPOS=(${lib.concatMapStringsSep " " (f: ''"${toString f}"'') backupFolders})
      else
          REPOS=("''${CUSTOM_PATHS[@]}")
      fi

      for repo in "''${REPOS[@]}"; do
          if [ ! -d "$repo/.git" ]; then
              echo "No git repo found in $repo, skipping..."
              continue
          fi
      done

      for repo in "''${REPOS[@]}"; do
          echo
          echo "=== Processing $repo ==="

          if [ ! -d "$repo/.git" ]; then
              echo "No git repo found in $repo, skipping..."
              continue
          fi

          cd "$repo" || continue

          git fetch origin &>/dev/null

          if git diff --quiet && git diff --cached --quiet && git status -uno | grep -q "up to date"; then
              echo "$repo is already up to date, skipping."
              continue
          fi

          if [ "$AUTO_CONFIRM" = false ]; then
              echo "--- Git status ---"
              git status
              echo "--- Git diff ---"
              git diff
          fi

          if [ "$USE_NORMAL_TIME" = true ]; then
              TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
          else
              TIMESTAMP=$(date +%s)
          fi

          if [ "$AUTO_CONFIRM" = true ]; then
              git add .
              COMMIT_MSG="Backup: $TIMESTAMP"
              git commit -m "$COMMIT_MSG"
              git push
              echo "Auto-pushed $repo"
          else
              read -p "Commit and push changes in $repo? (y/N): " choice
              if [[ "$choice" =~ ^[Yy]$ ]]; then
                  git add .
                  COMMIT_MSG="Backup: $TIMESTAMP"
                  git commit -m "$COMMIT_MSG"
                  git push
              else
                  echo "Skipped $repo"
              fi
          fi
      done
  '';
in {
  options.backupGit = {
    enable = lib.mkEnableOption "Enable backup-git";
    backupFolders = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [
        /home/brog/.config/nvim
        /home/brog/.config/nixos
        /home/brog/.config
      ];
    };
  };

  config = lib.mkIf config.backupGit.enable {
    home.packages = [
      backup-git
    ];
  };
}
