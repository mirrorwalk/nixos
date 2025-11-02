{inputs, ...}: let
  hmm = [
    ./home-manager/bat/bat.nix
    ./home-manager/browsers/browsers.nix
    ./home-manager/cava/cava.nix
    ./home-manager/fuzzel/fuzzel.nix
    ./home-manager/hypr/hypr.nix
    ./home-manager/nh/nh.nix
    ./home-manager/nom/nom.nix
    ./home-manager/nvim/nvim.nix
    ./home-manager/shells/shells.nix
    ./home-manager/terminals/terminals.nix
    ./home-manager/waybar/waybar.nix
    ./home-manager/version-control/vc.nix
    ./home-manager/file-managers/fm.nix
    ./home-manager/image-video/iv.nix
  ];

  sm = [
    ./system/style/style.nix
    ./system/system/system.nix
  ];

  cm = [
    ./custom/enix/enix.nix
    ./custom/git/git.nix
    ./custom/hyprpaper-random/hyprpaper-random.nix
    ./custom/tmux-startup/tmux-startup.nix
  ];

  im = [
    inputs.nvimFZF.default
  ];
in {
  imports = hmm ++ sm ++ cm ++ im;
}
