{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../zsh/zsh.nix
  ];

  home.shellAliases = {
        llll = "ls";
  };

}
