{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    hyprcursor
    rose-pine-hyprcursor
  ];
}
