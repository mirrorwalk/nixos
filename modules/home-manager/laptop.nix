{inputs, ...}: {
  imports = [
    ./default.nix
    ./nm-applet/nm-applet.nix
    ../custom/shutdown-menu/shutdown-menu.nix
    inputs.privateConfig.homeModules.laptop
  ];
}
