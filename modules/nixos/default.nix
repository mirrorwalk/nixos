{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./display-managers/display-managers.nix
    ./keyrings/keyrings.nix
    ./plymouth/plymouth.nix
    ./autousb.nix
    ./tor.nix
    ./games.nix
    ./wifi/wifi.nix
    inputs.home-manager.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    file
    unzip
    tree
    wl-clipboard
    pavucontrol
    exfatprogs
    unrar
    p7zip
  ];
}
