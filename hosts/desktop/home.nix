{
  pkgs,
  config,
  ...
}: {
  imports = [
  ];

  home.username = "brog";
  home.homeDirectory = "/home/brog";

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.json;
    defaultSopsFormat = "json";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

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
    blender
    kiwix
    aseprite
    bottles
    moor
    tauon
    spotdl
  ];

  home.sessionVariables = {
    PAGER = "moor";
  };

  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];

    config = {
      hyprland = {
        default = ["hyprland" "gtk"];
      };
      common = {
        default = ["hyprland" "gtk"];
      };
    };
  };

  games.enable = true;

  udiskie.enable = false;

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
    less = "moor";
  };

  music.enable = true;

  runners.fuzzel = {
    width = 50;
    innerPad = 5;
  };

  fileManagers = {
    thunar = {
      enable = true;
      defaultFileManager = true;
    };
    ranger = {
      enable = true;
      defaultFileManager = false;
    };
  };

  browsers = {
    mullvad = {
      enable = true;
      defaultBrowser = true;
    };
    brave.enable = true;
    chromium.enable = true;

    search.defaultEngine = "Kagi";
  };

  mopidy = {
      enable = false;
      spotify.enable = true;
  };

  programs = {
    ncmpcpp = {
      enable = false;

      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "J";
          command = ["select_item" "scroll_down"];
        }
        {
          key = "K";
          command = ["select_item" "scroll_up"];
        }
        {
          key = "l";
          command = "next_column";
        }
        {
          key = "l";
          command = "slave_screen";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "h";
          command = "master_screen";
        }
      ];
    };

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
  };

  privateConfig.gpg.enable = false;

  services = {
    ollama = {
      enable = false;
    };

    backupGit = {
      backupFolders = [
        /home/brog/.config/nixos-private
        /home/brog/.config/nixos
        /home/brog/.config/nvim
      ];
    };
  };

  desktop.hyprland = {
    animation = {
      enable = true;
    };

    fileManager = let
      term = config.systemConfig.defaults.terminal.command;

      package = pkgs.ranger;
    in "${term} -e ${package}/bin/ranger";
  };

  hypr = {
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
    # cava.enable = true;
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
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
  };

  programs.home-manager.enable = true;
}
