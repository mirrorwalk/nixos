{pkgs, ...}: {
  imports = [
    ../../modules/home-manager/laptop.nix
  ];

  home.username = "brog";
  home.homeDirectory = "/home/brog";

  # nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is

  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  services.gnome-keyring = {
    enable = true;
    components = ["secrets"];
  };

  imageVideo.mpv = {
    enable = true;
    default = {
      video = true;
      image = true;
      audio = true;
    };
  };

  wayland.windowManager.hyprland.enable = true;

  fileManagers = {
    thunar = {
      enable = true;
      defaultFileManager = true;
    };
  };

  systemConfig = {
    defaults = {
        enable = true;
        brightness.enable = true;
    };
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60.0;
      }
    ];
  };

  nmApplet = {
    enable = false;
    integration.hyprland = true;
  };

  runners.fuzzel = {
    enable = true;
    width = 50;
    dpiAware = "no";
    showActions = false;
  };

  shells = {
    bash.enable = true;
    tmux = {
      enable = true;
      tmuxStartup = {
        enable = true;
        aliasToTmux = true;
      };
    };
    bat.enable = true;
  };

  bars.waybar = {
    enable = true;
    interval = 5;
    battery.enable = true;
    systemService.enable = true;
    hyprland.enable = true;
    mullvadVPN.enable = true;
    backlight.enable = true;
  };

  browsers = {
    zen-browser = {
      enable = true;
      defaultBrowser = true;
      shortcuts.enable = true;
    };

    chromium = {
      enable = true;
    };

    librewolf = {
      enable = true;
    };

    mullvad = {
      enable = true;
    };

    adblock = {
        enable = true;
        provider = "adnauseam";
    };

    search.defaultEngine = "Kagi";
    search.private.defaultEngine = "ddg";
  };

  styleConfig = {
    defaultWallpaper = /home/brog/Pictures/Wallpapers/andromenda-galaxy.jpg;
    wallpaperFolders = [
      /home/brog/Pictures/Wallpapers
    ];
  };

  programs = {
    git = {
      enable = true;
      sign.enable = true;
    };

    jujutsu.enable = true;

    nh.enable = true;
    nom.enable = true;

    neovim.enable = true;

    fzf.enable = true;

    jq.enable = true;
    fd.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
  };

  services = {
    gitlab = {
      enable = true;
      ssh.enable = true;
    };

    github = {
      enable = true;
      ssh.enable = true;
    };

    setupGitRemotes = {
      enable = true;
    };

    backupGit = {
      enable = true;
      backupFolders = [
        /home/brog/.config/nixos-private
        /home/brog/.config/nixos
        /home/brog/.config
      ];
    };

    hyprpaper = {
      enable = true;
      random = {
        enable = false;
        interval = 3600;
        hyprland.enable = true;
      };
    };
  };

  terminals = {
    ghostty = {
      enable = true;
      defaultTerminal = true;
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

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  programs.home-manager.enable = true;
}
