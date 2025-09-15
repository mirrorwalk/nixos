{config, ...}: {
  programs.git = {
    enable = true;
    userName = "mirrorwalk";
    userEmail = "git.cresting327@passmail.net";

    aliases = {
      st = "status";
      s = "status --short";
      d = "diff";
      p = "push";
      b = "branch";
      ba = "branch -a";
      lg = "log --oneline --graph --all --decorate";
      l = "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short";

      ci = "commit";
      cm = "commit -m";

      co = "checkout";
      cb = "checkout -b";
    };

    # signing = {
    #     signByDefault = true;
    #     key = "204104CBF418A401";
    # };

    extraConfig = {
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
      core = {
        editor = "nvim";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
      };
      gpg.format = "ssh";
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
      user.signingkey = "~/.ssh/git";
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };
  };

  programs.ssh.matchBlocks = {
    "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/git";
    };
    "gitlab.com" = {
      hostname = "gitlab.com";
      user = "git";
      identityFile = "~/.ssh/git";
    };
  };
}
