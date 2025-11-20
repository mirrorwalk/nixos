{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprshot.nix
  ];

  home.packages = with pkgs; [
    # hyprcursor
    rose-pine-hyprcursor
  ];
}
