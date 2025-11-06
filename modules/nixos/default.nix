{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./display-managers/display-managers.nix
    ./keyrings/keyrings.nix
    ./plymouth/plymouth.nix
    inputs.home-manager.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    file
    unzip
    tree
    wl-clipboard
    pavucontrol
    exfatprogs
  ];
}
