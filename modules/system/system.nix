{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./monitors.nix
    ./style.nix
  ];

  options.systemConfig.defaultImports = mkOption {
    type = types.listOf types.path;
    default = [
      ./bat/bat.nix
      ./browsers/browsers.nix
      ./cava/cava.nix
      ./fuzzel/fuzzel.nix
      ./hypr/hypr.nix
      ./nh/nh.nix
      ./nom/nom.nix
      ./nvim/nvim.nix
      ./shells/shells.nix
      ./terminals/terminals.nix
      ./waybar/waybar.nix
      ./version-control/vc.nix
    ];
  };
}
