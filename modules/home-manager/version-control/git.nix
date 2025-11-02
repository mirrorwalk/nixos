{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.git;
in {
  imports = [
    ../../custom/git/git.nix
  ];

  options.git = {
    enable = lib.mkEnableOption "Enable git";

    github = {
      enable = lib.mkEnableOption "Enable github";
      sshFile = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "~/.ssh/git";
      };
    };

    gitlab = {
      enable = lib.mkEnableOption "Enable github";
      sshFile = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "~/.ssh/git";
      };
    };

    ssh.enable = lib.mkEnableOption "Enable ssh for git";

    signKey = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "~/.ssh/git";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh.enable = lib.mkIf cfg.github.enable true;
    home.packages = lib.mkIf cfg.github.enable [
      pkgs.glab
    ];

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "mirrorwalk";
          email = "git.cresting327@passmail.net";
          signingkey = lib.mkIf cfg.ssh.enable cfg.signKey;
        };

        alias = {
          st = "status";
          s = "status --short";
          d = "diff";
          p = "push";
          b = "branch";
          ba = "branch -a";
          lg = "log --oneline --graph --all --decorate";
          l = "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short";

          c = "commit";
          ca = "commit -a -m";
          cm = "commit -m";

          co = "checkout";
          cob = "checkout -b";
        };

        branch = {
          sort = "-committerdate";
        };
        column = {
          ui = "auto";
        };
        commit = {
          gpgSign = "true";
          verbose = "true";
        };
        gpg.format = "ssh";
        core = {
          editor = "nvim";
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
        };
        help = {
          autocorrect = "prompt";
        };
        init = {
          defaultBranch = "master";
        };
        merge = {
          conflictStyle = "zdiff3";
        };
        prone = {
          prune = "true";
          pruneTags = "true";
        };
        pull = {
          rebase = "true";
        };
        push = {
          autoSetupRemote = "true";
          default = "simple";
          followTags = "true";
        };
        rerere = {
          autoupdate = "true";
          enabled = "true";
        };
        tag = {
          sort = "version:refname";
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };

    programs.ssh.matchBlocks = lib.mkIf cfg.ssh.enable {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        # identityFile = "~/.ssh/git";
        identityFile = cfg.github.sshFile;
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = cfg.gitlab.sshFile;
      };
    };
  };
}
