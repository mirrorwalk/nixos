{

  programs.git = {
    enable = true;
    userName = "mirrorwalk";
    userEmail = "git.cresting327@passmail.net";

    aliases = {
        st = "status";
        s = "status --short";
        br = "branch";
        bra = "branch -a";
        lg = "log --oneline --graph --all --decorate";
        l = "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short";

        ci = "commit";
        cm = "commit -m";

        co = "checkout";
        cb = "checkout -b";
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "master";
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
      };
      push = {
        default = "simple";
        autoSetupRemote = "true";
        followTags = "true";
      };
      prone = {
        prune = "true";
        pruneTags = "true";
      };
      commit = {
        verbose = "true";
      };
      help = {
        autocorrect = "prompt";
      };
      rerere = {
        enabled = "true";
        autoupdate = "true";
      };
      merge = {
        conflictStyle = "zdiff3";
      };
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
}
