{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./zsh.nix
    ./bash.nix
    ./fish.nix
    ./tmux.nix
    ./nushell.nix
    ../../custom/enix/enix.nix
  ];
  options.shells = {
    bat.enable = lib.mkEnableOption "Enable the bat pager";
  };

  config = {
    home.shellAliases = {
      backup-message = "echo Backup: $(date '+%Y-%m-%d %H:%M:%S')";
      evi = "cd $HOME/.config/nvim && nvim .";
      la = "ls -AF --color=auto";
      tmuxs = "${pkgs.tmux}/bin/tmux new -s";
      tmuxa = "${pkgs.tmux}/bin/tmux attach-session -t nixos || ${pkgs.tmux}/bin/tmux switch-client -t ";
      nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell";
      nix-build = "${pkgs.nix-output-monitor}/bin/nom-build";
      nix = "${pkgs.nix-output-monitor}/bin/nom";
      cat = "${pkgs.bat}/bin/bat";
      rnos = "${pkgs.nh}/bin/nh os switch";
      nosr = "${pkgs.nh}/bin/nh os switch";
      nr = "${pkgs.nh}/bin/nh os switch";
      nt = "${pkgs.nh}/bin/nh os test";
      rn = "${pkgs.nh}/bin/nh os switch";
      ns = "${pkgs.nh}/bin/nh os switch";
      nos = "${pkgs.nh}/bin/nh os switch";
      nd = "${pkgs.nix-output-monitor}/bin/nom develop";
      ytdb = "${pkgs.yt-dlp}/bin/yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]'";
      flake = "${pkgs.nix}/bin/nix flake";
    };

    programs.bat = lib.mkIf config.shells.bat.enable {
      enable = true;
    };
    home.sessionVariables = lib.mkIf config.shells.bat.enable {
      PAGER = "bat";
    };
  };
}
