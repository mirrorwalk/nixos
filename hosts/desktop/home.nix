{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports =
    [
      ../../modules/home-manager/hyprland/hyprland.nix
      ../../modules/home-manager/ghostty/ghostty.nix
      ../../modules/home-manager/waybar/waybar.nix
      ../../modules/home-manager/git/git.nix
      ../../modules/home-manager/jj/jj.nix
      ../../modules/home-manager/nvim/nvim.nix
      ../../modules/home-manager/browsers/browsers.nix
      ../../modules/home-manager/shells/shells.nix
      ../../modules/custom/backup-git/backup-git.nix
    ]
    ++ lib.optionals (inputs ? privateConfig) [
      inputs.privateConfig.homeModules.desktop
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
    pkgs.mullvad-vpn
    pkgs.ripgrep
    pkgs.pavucontrol
    pkgs.mullvad-browser
    pkgs.tor
    pkgs.tor-browser
    pkgs.pipewire
    pkgs.wofi
    pkgs.keepassxc
    pkgs.mpv
    pkgs.brave
    pkgs.hyprcursor
    pkgs.xwayland-satellite
    pkgs.cryptsetup
    pkgs.wl-clipboard
    pkgs.qbittorrent
    pkgs.btop
    pkgs.wine
    pkgs.tree
    pkgs.fd
    pkgs.jq
    pkgs.kdePackages.dolphin
    pkgs.nix-output-monitor
    pkgs.lutris
    pkgs.protonup
    pkgs.yt-dlp
    pkgs.rose-pine-hyprcursor
  ];

  browsers = {
    zen-browser.enable = true;
    librewolf.enable = true;
  };

  hyprpaper = {
    enable = true;
    random = {
      enable = true;
      interval = "300";
      hyprland = {
        exec = true;
        integration = true;
      };
      wallpaperFolders = [
        "/home/brog/Pictures/Wallpapers"
        "/home/brog/Pictures/Wallpapers/nature/"
        "/home/brog/Pictures/Wallpapers/animals/"
      ];
    };
  };

  waybar = {
    hyprland.enable = true;
    mullvad.enable = true;
    wallpaper.enable = true;
  };

  shells = {
    bash.enable = true;
    tmux = {
      enable = true;
      shellAliases.enable = true;
      tmuxStartup = {
        enable = true;
        ghosttyIntegration = true;
      };
      tmux-workspace = {
        enable = true;
        rootFolders = {
          "${config.home.homeDirectory}/projects" = "1:1";
          "${config.home.homeDirectory}/projects/zig" = "1:1";
          "${config.home.homeDirectory}/projects/svelte" = "1:1";
          "${config.home.homeDirectory}/projects/python" = "1:1";
          "${config.home.homeDirectory}/.config" = "1:1";
          "${config.home.homeDirectory}/.config/nvim" = "0:1";
        };

        customWindows = {
          "${config.home.homeDirectory}/projects/passim" = "code:terminal";
          "${config.home.homeDirectory}/projects/zig/taskrhythm" = "code:terminal";
          "${config.home.homeDirectory}/projects/svelte/TaskFlow" = "code:server";
          "${config.home.homeDirectory}/projects/TaterRogue" = "code:terminal";
        };
      };
    };
    nu.enable = true;
  };

  programs.nvim-fzf = {
    enable = true;
    bashIntegration.enable = true;
    roots = [
      "$HOME/.config/nixos"
      "$HOME/.config"
      "$HOME/projects"
      "$HOME/notes"
      "$HOME/.local/bin"
    ];
    ignore = [
      ".git"
      "node_modules"
      "target"
      ".direnv"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  wayland.windowManager.hyprland.enable = true;

  home.keyboard = {
      xkbOptions = [ "caps:escape" ];
  };

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
