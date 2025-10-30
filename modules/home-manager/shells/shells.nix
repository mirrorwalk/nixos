{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./zsh.nix
    ./bash.nix
    ./fish.nix
    ./tmux.nix
    ./nushell.nix
    ./sh-functions.nix
    ../bat/bat.nix
    ../../custom/enix/enix.nix
  ];

  config = {
    home.shellAliases = {
      la = "ls -AF --color=auto";
    };
  };
}
