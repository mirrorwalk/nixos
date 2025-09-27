{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    ../../modules/home-manager/hyprland/desktop-hyprland.nix
    ../../modules/home-manager/ghostty/ghostty.nix
    ../../modules/home-manager/waybar/waybar.nix
    ../../modules/home-manager/git/git.nix
    ../../modules/home-manager/jj/jj.nix
    ../../modules/home-manager/tmux/tmux.nix
    ../../modules/home-manager/bash/bash.nix
    ../../modules/home-manager/gpg/gpg.nix
    ../../modules/home-manager/ssh/ssh.nix
    ../../modules/home-manager/nvim/nvim.nix
    ../../modules/custom/nvim-fzf/nvim-fzf.nix
    ../../modules/custom/tmux-workspace/tmux-workspace.nix
    ../../modules/custom/hyprpaper/hyprpaper.nix
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
    pkgs.librewolf
    pkgs.ripgrep
    pkgs.pavucontrol
    pkgs.mullvad-vpn
    pkgs.mullvad-browser
    pkgs.tor
    pkgs.tor-browser
    pkgs.pipewire
    pkgs.wofi
    pkgs.keepassxc
    pkgs.mpv
    pkgs.brave
    pkgs.hyprcursor
    # pkgs.fuzzel
    pkgs.xwayland-satellite
    pkgs.cryptsetup
    pkgs.wl-clipboard
    pkgs.jujutsu
    # pkgs.vscode-fhs
    pkgs.gh
    pkgs.freetube
    pkgs.qbittorrent
    # pkgs.calibre
    # pkgs.zed-editor
    # pkgs.inotify-tools
    pkgs.swaybg
    pkgs.btop
    pkgs.wine
    pkgs.tree
    pkgs.fd
    pkgs.jq
    pkgs.bat
    # pkgs.liferea
    pkgs.kdePackages.dolphin
    pkgs.file
    pkgs.unzip
    pkgs.nix-output-monitor
    pkgs.nushell
    # pkgs.tokei
    # pkgs.lm_sensors
    pkgs.godot
    pkgs.seahorse

    # Themes
    pkgs.adwaita-qt
    pkgs.gnome-themes-extra
    pkgs.gsettings-desktop-schemas
  ];

  waybar.hyprland.enable = true;
  waybar.mullvad.enable = true;
  waybar.weatherCity = "Prague";

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  wayland.windowManager.hyprland.enable = true;

  systemd.user.services = {
    # swaybg-random = {
    #   Unit = {
    #     Description = "swaybg wallpaper background";
    #     After = ["niri.service"];
    #     PartOf = ["niri.service"];
    #   };
    #   Service = {
    #     ExecStart = "%h/.local/bin/swaybg-random-wallpaper.sh";
    #     Restart = "on-failure";
    #   };
    #   Install = {
    #     WantedBy = ["niri.service"];
    #   };
    # };
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

  home.file = {
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    PAGER = "bat";
  };

  programs.home-manager.enable = true;
}
