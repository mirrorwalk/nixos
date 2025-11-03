{inputs, ...}: {
  imports = [
    ./default.nix
    ./games/games.nix
    inputs.privateConfig.homeModules.desktop
  ];
}
