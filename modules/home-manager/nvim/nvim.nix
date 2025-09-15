{pkgs, ...}:
{
  home.packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.git
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.sessionVariables = {
    VISUAL = "nvim";
  };
}
