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
    ../../modules/home-manager/nh/nh.nix
    ../../modules/home-manager/nom/nom.nix
    ../../modules/home-manager/fuzzel/fuzzel.nix
    ../../modules/home-manager/hyprpaper/hyprpaper.nix
    # ../../modules/custom/backup-git/backup-git.nix
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
    pkgs.pipewire
    pkgs.mpv
    pkgs.hyprcursor
    pkgs.wl-clipboard
    pkgs.btop
    pkgs.tree
    pkgs.fd
    pkgs.jq
    pkgs.xfce.thunar
    pkgs.rose-pine-hyprcursor
    pkgs.networkmanagerapplet
  ];

  hyprland = {
    fileManager = "thunar";
    webBrowser = "zen-twilight";
  };

  systemConfig.monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60.0;
    }
  ];

  home.shellAliases = {
    syss = "systemctl --user status";
    sysst = "systemctl --user stop";
    sysr = "systemctl --user restart";
  };

  # services.network-manager-applet.enable = true;

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "nm-applet"
      ];
    };
  };

  programs.fzf.enable = true;

  fuzzel = {
    # width = 50;
    # horizontalPad = 20;
    # verticalPad = 8;
    # innerPad = 8;
    dpiAware = "no";
    # showActions = "no";
    showActions = false;
  };

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
    interval = 5;
    systemService = true;
    hyprland.enable = true;
    mullvad.enable = false;
  };

  backupGit = {
    enable = true;
    backupFolders = [
      /home/brog/.config/nixos
    ];
  };

  nh.enable = true;
  nom.enable = true;

  browsers = {
    zen-browser = {
      enable = true;
      defaultBrowser = true;
    };
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
      enable = true;
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
