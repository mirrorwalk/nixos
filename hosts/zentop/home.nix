{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager/hyprland/hyprland.nix
    ../../modules/home-manager/ghostty/ghostty.nix
    ../../modules/home-manager/git/git.nix
    ../../modules/home-manager/jj/jj.nix
    ../../modules/home-manager/shells/shells.nix
    ../../modules/home-manager/nvim/nvim.nix
    ../../modules/home-manager/browsers/browsers.nix
    ../../modules/home-manager/waybar/waybar.nix
    ../../modules/home-manager/shells/shells.nix
    ../../modules/custom/backup-git/backup-git.nix
    ../../modules/system-config/system-config.nix
    ../../modules/style-config/style-config.nix
    inputs.privateConfig.homeModules.laptop
  ];

  home.username = "brog";
  home.homeDirectory = "/home/brog";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is

  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.exfatprogs
    pkgs.ripgrep
    pkgs.pavucontrol
    pkgs.mullvad-browser
    pkgs.pipewire
    pkgs.wofi
    pkgs.mpv
    pkgs.hyprcursor
    pkgs.xwayland-satellite
    pkgs.cryptsetup
    pkgs.wl-clipboard
    pkgs.btop
    pkgs.tree
    pkgs.fd
    pkgs.jq
    pkgs.kdePackages.dolphin
    pkgs.nix-output-monitor
    pkgs.yt-dlp
  ];

  systemConfig.monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60.0;
    }
  ];

  shells = {
    bash.enable = true;
    tmux = {
      enable = true;
      tmuxStartup = {
        enable = true;
        ghosttyIntegration = true;
      };
    };
    bat.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  waybar = {
    hyprland.enable = true;
    mullvad.enable = false;
  };

  browsers.zen-browser.enable = true;

  wayland.windowManager.hyprland.enable = true;

  programs.git.settings.user.signingkey = "~/.ssh/git";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["mullvad-browser.desktop"];
      "x-scheme-handler/http" = ["mullvad-browser.desktop"];
      "x-scheme-handler/https" = ["mullvad-browser.desktop"];
      "x-scheme-handler/about" = ["mullvad-browser.desktop"];
      "x-scheme-handler/unknown" = ["mullvad-browser.desktop"];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
    platformTheme.name = "gtk3";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  programs.nh = {
    enable = true;
    flake = "/home/brog/.config/nixos";
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  programs.home-manager.enable = true;
}
