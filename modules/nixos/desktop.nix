{pkgs, ...}: {
  imports = [
    ./default.nix
    ./games.nix
  ];
  environment.systemPackages = with pkgs; [
    wine
  ];
}
