{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/home-manager/desktop.nix
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

  home.packages = with pkgs; [
    qbittorrent
  ];

  wayland.windowManager.hyprland.enable = true;

  games.enable = true;

  imageVideo.mpv = {
    enable = true;
    default = {
      video = true;
      image = true;
      audio = true;
    };
  };

  fileManagers = {
    thunar = {
      enable = true;
      defaultFileManager = true;
    };
    dolphin.enable = true;
  };

  styleConfig = {
    defaultWallpaper = /home/brog/Pictures/Wallpapers/thumb-1920-1345286.png;
    wallpaperFolders = [
      /home/brog/Pictures/Wallpapers
      /home/brog/Pictures/Wallpapers/nature
      /home/brog/Pictures/Wallpapers/animals
    ];
  };

  systemConfig = {
    defaults.enable = true;
    monitors = [
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        refreshRate = 120.0;
      }
    ];
  };

  home.shellAliases = {
    ytdb = "${pkgs.yt-dlp}/bin/yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]'";
    flake = "${pkgs.nix}/bin/nix flake";
    backup-message = "echo Backup: $(date '+%Y-%m-%d %H:%M:%S')";
    evi = "cd $HOME/.config/nvim && nvim .";
  };

  runners.fuzzel = {
    enable = true;
    width = 50;
    innerPad = 5;
  };

  browsers = {
    zen-browser.enable = true;
    mullvad = {
      enable = true;
      defaultBrowser = true;
    };

    brave.enable = true;

    adblock = {
      enable = true;
      provider = "adnauseam";
    };
    search.defaultEngine = "Kagi";
  };

  programs = {
    git = {
      enable = true;
      sign.enable = true;
    };

    jujutsu.enable = true;

    nh.enable = true;
    nom.enable = true;

    yt-dlp.enable = true;

    neovim.enable = true;

    fzf.enable = true;

    jq.enable = true;
    fd.enable = true;
    btop.enable = true;
    ripgrep.enable = true;

    cava.enable = true;

    keepassxc.enable = true;

    nvim-fzf = {
      enable = true;
      bashKeybind.enable = true;
      roots = [
        "${config.home.homeDirectory}/.config/nixos"
        "$HOME/.config"
        "$HOME/projects"
        "$HOME/.local/bin"
      ];
      ignore = [
        ".git"
        "node_modules"
        "target"
        ".direnv"
      ];
    };
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
        /home/brog/.config/nvim
        /home/brog/.config
      ];
    };


    hyprpaper = {
      enable = true;
      random = {
        enable = true;
        scriptName = "hrc";
        interval = 300;
        hyprland.enable = true;
      };
    };
  };

  notif.mako.enable = true;

  bars.waybar = {
    enable = true;
    systemService.enable = true;
    hyprland.enable = true;
    mullvadVPN.enable = true;
    wallpaperCategory.enable = true;
    cava.enable = true;
    weather.enable = true;
  };

  terminals = {
    ghostty = {
      enable = true;
      defaultTerminal = true;
    };
    kitty.enable = true;
  };

  shells = {
    bash.enable = true;
    nu.enable = true;
    tmux = {
      enable = true;
      tmuxStartup = {
        enable = true;
        aliasToTmux = true;
      };
      tmux-workspace = {
        enable = true;
        rootFolders = {
          "${config.home.homeDirectory}/projects" = "1:1";
          "${config.home.homeDirectory}/projects/zig" = "1:1";
          "${config.home.homeDirectory}/projects/svelte" = "1:1";
          "${config.home.homeDirectory}/.config" = "1:1";
          "${config.home.homeDirectory}/.config/nvim" = "0:1";
        };
      };
    };
    bat.enable = true;
  };

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  home.keyboard = {
    xkbOptions = ["caps:escape"];
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
