{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
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

  home.packages = with pkgs; [
    qbittorrent
    godot
    # kdePackages.kleopatra
    # pinentry-curses
  ];

  games.enable = true;

  styleConfig = {
    defaultWallpaper = /home/brog/Pictures/Wallpapers/thumb-1920-1345286.png;
    wallpaperFolders = [
      /home/brog/Pictures/Wallpapers
      /home/brog/Pictures/Wallpapers/nature
      /home/brog/Pictures/Wallpapers/animals
    ];
  };

  systemConfig = {
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

  programs = {
    yt-dlp.enable = true;

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

    # gpg.enable = true;
  };

  privateConfig.gpg.enable = false;

  services = {
    # gpg-agent = {
    #   enable = true;
    #   pinentry.package = pkgs.pinentry-curses;
    # };

    backupGit = {
      backupFolders = [
        /home/brog/.config/nixos-private
        /home/brog/.config/nixos
        /home/brog/.config/nvim
      ];
    };

    hyprpaper = {
      random = {
        enable = true;
        scriptName = "hrc";
        interval = 300;
        hyprland.enable = true;
      };
    };
  };

  bars.waybar = {
    wallpaperCategory.enable = true;
    cava.enable = true;
    weather.enable = true;
  };

  shells = {
    nu.enable = true;
    tmux = {
      tmux-workspace = {
        enable = true;
        rootFolders = {
          # "${config.home.homeDirectory}/projects" = "1:2";
          "${config.home.homeDirectory}/projects/zig" = "1:1";
          "${config.home.homeDirectory}/projects/godot" = "1:1";
          "${config.home.homeDirectory}/.config" = "1:1";
          "${config.home.homeDirectory}/.config/nvim" = "0:1";
        };
      };
    };
  };

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
