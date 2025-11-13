{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    # hyprcursor
    rose-pine-hyprcursor
  ];
}
