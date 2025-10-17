{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "mirrorwalk";
        email = "git.cresting327@passmail.net";
      };
      ui = {
        paginate = "never";
        default-command = "status";
      };
      aliases = {
        init = ["git" "init" "--colocate"];
        push = ["git" "push"];
        pushr = ["git" "push" "--remote"];
        d = ["diff" "--color=always"];
        n = ["new"];
        l = ["log" "--color=always"];
      };
    };
  };
}
