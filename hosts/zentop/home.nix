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

  home.packages = with pkgs; [
    kiwix
  ];

  udiskie.enable = false;

  services.gnome-keyring = {
    enable = true;
    components = ["secrets"];
  };

  shutdownMenu.enable = true;

  fileManagers = {
    thunar = {
      enable = true;
      defaultFileManager = false;
    };
    ranger = {
      enable = true;
      defaultFileManager = true;
    };
  };

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

  desktop.hyprland = {
    volumeBinds.enable = true;
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
