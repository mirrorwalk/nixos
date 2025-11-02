{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.git;

  setupGitRemotes = pkgs.writeShellScriptBin "${cfg.setupGitRemotes.scriptName}" ''
    #!/usr/bin/env bash

    # Configuration from NixOS module
    GITHUB_ENABLED=${lib.boolToString cfg.github.enable}
    GITLAB_ENABLED=${lib.boolToString cfg.gitlab.enable}

    # Get repository name from current directory
    REPO_NAME=$(basename "$(pwd)")

    # Parse flags
    ADD_GITHUB=false
    ADD_GITLAB=false
    ADD_ORIGIN=false

    while [[ $# -gt 0 ]]; do
      case $1 in
        -gh|--github)
          ADD_GITHUB=true
          shift
          ;;
        -gl|--gitlab)
          ADD_GITLAB=true
          shift
          ;;
        *)
          echo "Unknown option: $1"
          echo "Usage: setup-git-remotes [-gh|--github] [-gl|--gitlab]"
          exit 1
          ;;
      esac
    done

    # If no flags provided, add origin with enabled remotes
    if [[ "$ADD_GITHUB" == false && "$ADD_GITLAB" == false ]]; then
      ADD_ORIGIN=true
    fi

    # Add origin with enabled remotes
    if [[ "$ADD_ORIGIN" == true ]]; then
      if [[ "$GITHUB_ENABLED" == "true" && "$GITLAB_ENABLED" == "true" ]]; then
        # Both enabled: dual push setup
        if git remote get-url origin &>/dev/null; then
            echo "Origin remote already exists, updating..."
            git remote set-url origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
            git remote set-url --add --push origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
            git remote set-url --add --push origin "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        else
            echo "Adding origin remote with both GitHub and GitLab..."
            git remote add origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
            git remote set-url --add --push origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
            git remote set-url --add --push origin "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        fi
      elif [[ "$GITHUB_ENABLED" == "true" ]]; then
        # Only GitHub enabled
        if git remote get-url origin &>/dev/null; then
            echo "Origin remote already exists, updating to GitHub..."
            git remote set-url origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
        else
            echo "Adding origin remote (GitHub)..."
            git remote add origin "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
        fi
      elif [[ "$GITLAB_ENABLED" == "true" ]]; then
        # Only GitLab enabled
        if git remote get-url origin &>/dev/null; then
            echo "Origin remote already exists, updating to GitLab..."
            git remote set-url origin "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        else
            echo "Adding origin remote (GitLab)..."
            git remote add origin "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        fi
      else
        echo "Error: No git remotes enabled in configuration"
        exit 1
      fi
    fi

    # Add GitHub remote (only if enabled)
    if [[ "$ADD_GITHUB" == true ]]; then
      if [[ "$GITHUB_ENABLED" == "true" ]]; then
        if git remote get-url github &>/dev/null; then
            echo "GitHub remote already exists, updating..."
            git remote set-url github "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
        else
            echo "Adding GitHub remote..."
            git remote add github "git@github.com:${cfg.github.username}/''${REPO_NAME}.git"
        fi
      else
        echo "Warning: GitHub remote requested but not enabled in configuration"
      fi
    fi

    # Add GitLab remote (only if enabled)
    if [[ "$ADD_GITLAB" == true ]]; then
      if [[ "$GITLAB_ENABLED" == "true" ]]; then
        if git remote get-url gitlab &>/dev/null; then
            echo "GitLab remote already exists, updating..."
            git remote set-url gitlab "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        else
            echo "Adding GitLab remote..."
            git remote add gitlab "git@gitlab.com:${cfg.gitlab.username}/''${REPO_NAME}.git"
        fi
      else
        echo "Warning: GitLab remote requested but not enabled in configuration"
      fi
    fi

    # Display configured remotes
    echo -e "\nConfigured remotes:"
    git remote -v

    echo -e "\nDone!"
  '';
in {
  options.git = {
    setupGitRemotes = {
      enable = lib.mkEnableOption "Enable setup-git-remotes script";

      scriptName = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "setup-git-remotes";
      };
    };

    gitlab = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "mirr0rwalk";
        description = "GitLab username";
      };
    };
    github = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "mirrorwalk";
        description = "GitHub username";
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.setupGitRemotes.enable) {
    home.packages = [
      setupGitRemotes
    ];

    # home.shellAliases = {
    #   sgr = "${setupGitRemotes}/bin/setup-git-remotes";
    # };
  };
}
