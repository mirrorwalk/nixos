{pkgs, ...}: {
  home.packages = with pkgs; [
    lutris
    protonup-ng
  ];
}
