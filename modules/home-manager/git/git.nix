{pkgs, ...}: {
  programs.gh.enable = true;
  home.packages = [
    pkgs.glab
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mirrorwalk";
        email = "git.cresting327@passmail.net";
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

        ci = "commit";
        cm = "commit -m";

        co = "checkout";
        cb = "checkout -b";
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
}
