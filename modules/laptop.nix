{inputs, ...}: {
  imports = [
    ./default.nix
    ./home-manager/nm-applet/nm-applet.nix
    inputs.privateConfig.homeModules.desktop
  ];
}
