{inputs, ...}: {
  imports = [
    ./default.nix
    ./home-manager/nm-applet/nm-applet.nix
    ./custom/shutdown-menu/shutdown-menu.nix
    inputs.privateConfig.homeModules.laptop
  ];
}
