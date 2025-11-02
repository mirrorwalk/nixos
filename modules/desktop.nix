{inputs, ...}: {
  imports = [
    ./default.nix
    ./home-manager/games/games.nix
    inputs.privateConfig.homeModules.desktop
  ];
}
