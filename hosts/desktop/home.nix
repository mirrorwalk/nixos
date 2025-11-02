{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ../../modules/desktop.nix
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
    file
    unzip
    exfatprogs
    ripgrep
    pavucontrol
    tor
    tor-browser
    pipewire
    keepassxc
    # xwayland-satellite
    # cryptsetup
    wl-clipboard
    qbittorrent
    btop
    wine
    tree
    fd
    jq
    yt-dlp
  ];

  hyprland.enable = true;

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
    default.enable = true;
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

  fuzzel = {
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
    search.defaultEngine = "Kagi";
  };

  programs.fzf.enable = true;

  git = {
    enable = true;
    ssh.enable = true;
    setupGitRemotes = {
      enable = true;
      scriptName = "sgr";
    };
    gitlab.enable = true;
    github.enable = true;
  };

  jj.enable = true;

  backupGit = {
    enable = true;

    backupFolders = [
      /home/brog/.config/nvim
      /home/brog/.config/nixos-private
      /home/brog/.config/nixos
      /home/brog/.config
    ];
  };

  hyprpaper = {
    enable = true;
    random = {
      scriptName = "hrc";
      enable = true;
      interval = 300;
      hyprland.enable = true;
    };
  };

  cava.enable = true;

  waybar = {
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

  nh.enable = true;
  nom.enable = true;

  nvim.enable = true;

  programs.nvim-fzf = {
    enable = true;
    bashKeybind.enable = true;
    roots = [
      "$HOME/.config/nixos"
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

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  wayland.windowManager.hyprland.enable = true;

  home.keyboard = {
    xkbOptions = ["caps:escape"];
  };

  xdg.mimeApps.enable = true;

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
