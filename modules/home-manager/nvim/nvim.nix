{pkgs, ...}:
{
  home.packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.git
    pkgs.cargo
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
