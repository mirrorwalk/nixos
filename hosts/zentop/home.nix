{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/laptop.nix
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
    exfatprogs
    ripgrep
    pavucontrol
    pipewire
    wl-clipboard
    btop
    tree
    fd
    jq
  ];

  services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
  };

  imageVideo.mpv = {
    enable = true;
    default = {
      video = true;
      image = true;
      audio = true;
    };
  };

  nvim.enable = true;
  hyprland.enable = true;

  fileManagers = {
    thunar = {
      enable = true;
      defaultFileManager = true;
    };
  };

  systemConfig = {
    default.enable = true;
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
    enable = true;
    integration.hyprland = true;
  };

  programs.fzf.enable = true;

  fuzzel = {
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  waybar = {
    enable = true;
    interval = 5;
    battery.enable = true;
    systemService.enable = true;
    hyprland.enable = true;
    mullvadVPN.enable = true;
  };

  backupGit = {
    enable = true;
    backupFolders = [
      /home/brog/.config/nixos
      /home/brog/.config
    ];
  };

  nh.enable = true;
  nom.enable = true;

  browsers = {
    zen-browser = {
      enable = true;
      defaultBrowser = true;
    };
    mullvad = {
      enable = true;
    };
    librewolf.enable = true;
    search.defaultEngine = "Kagi";
    search.private.defaultEngine = "ddg";
  };

  wayland.windowManager.hyprland.enable = true;

  styleConfig = {
    defaultWallpaper = /home/brog/Pictures/Wallpapers/andromenda-galaxy.jpg;
    wallpaperFolders = [
      /home/brog/Pictures/Wallpapers
    ];
  };

  hyprpaper = {
    enable = true;
    random = {
      enable = false;
      scriptName = "hrc";
      interval = 3600;
      hyprland.enable = true;
    };
  };

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

  terminals.ghostty.enable = true;

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
