{pkgs, inputs, ...}: {
  imports = [
    inputs.nvimFZF.default
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = [
      pkgs.gcc
      pkgs.gnumake
      pkgs.git
      pkgs.cargo
      pkgs.nodejs
    ];
  };

  home.sessionVariables = {
    VISUAL = "nvim";
  };
}
