{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.git;
in {
  options.programs.git = {
    sign = {
      enable = lib.mkEnableOption "Enable signing git commits";
      key = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "~/.ssh/git";
      };
    };
  };

  config = {
    programs.git = {
      settings = {
        user = {
          name = "mirrorwalk";
          email = "git.cresting327@passmail.net";
          signingkey = lib.mkIf cfg.sign.enable cfg.sign.key;
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
          gpgSign = lib.mkIf cfg.sign.enable "true";
          verbose = "true";
        };
        gpg.format = lib.mkIf cfg.sign.enable "ssh";
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
      enable = cfg.enable;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };
  };
}
