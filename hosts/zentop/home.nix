{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
    inputs.privateConfig.homeModules.laptop
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

  shutdownMenu.enable = true;

  systemConfig = {
    defaults = {
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
    enable = true;
    integration.hyprland = true;
  };

  runners.fuzzel = {
    width = 50;
    dpiAware = "no";
    showActions = false;
  };

  bars.waybar = {
    interval = 5;
    battery.enable = true;
    backlight.enable = true;
  };

  browsers = {
    zen-browser = {
      enable = true;
      defaultBrowser = true;
      shortcuts.enable = true;
    };

    tor.enable = true;
    mullvad.enable = true;

    search.defaultEngine = "Kagi";
    search.private.defaultEngine = "ddg";
  };

  styleConfig = {
    defaultWallpaper = /home/brog/Pictures/Wallpapers/andromenda-galaxy.jpg;
    wallpaperFolders = [
      /home/brog/Pictures/Wallpapers
    ];
  };

  services = {
    backupGit = {
      backupFolders = [
        /home/brog/.config/nixos-private
        /home/brog/.config/nixos
        /home/brog/.config
      ];
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
