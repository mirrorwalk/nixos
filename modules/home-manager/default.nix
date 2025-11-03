{inputs, ...}: let
  hmm = [
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
    ./file-managers/fm.nix
    ./image-video/iv.nix
  ];

  sm = [
    ../system/style/style.nix
    ../system/system/system.nix
  ];

  cm = [
    ../custom/enix/enix.nix
    ../custom/git/git.nix
    ../custom/hyprpaper-random/hyprpaper-random.nix
    ../custom/tmux-startup/tmux-startup.nix
  ];

  im = [
    inputs.nvimFZF.default
  ];
in {
  imports = hmm ++ sm ++ cm ++ im;
}
