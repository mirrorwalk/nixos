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
    ../../modules/home-manager/zsh/zsh.nix
    ../../modules/home-manager/gpg/gpg.nix
    ../../modules/home-manager/ssh/ssh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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
    pkgs.fzf
    pkgs.pavucontrol
    pkgs.mullvad-vpn
    pkgs.mullvad-browser
    pkgs.tor
    pkgs.tor-browser
    pkgs.pipewire
    pkgs.pulseaudio
    pkgs.wofi
    pkgs.keepassxc
    pkgs.mpv
    pkgs.brave
    pkgs.direnv
    pkgs.hyprcursor
    pkgs.fuzzel
    pkgs.xwayland-satellite
    pkgs.cryptsetup
    pkgs.wl-clipboard
    pkgs.python314
    pkgs.jujutsu
    pkgs.vscode-fhs
    pkgs.nodejs_24
    pkgs.bun
    pkgs.go
    pkgs.gh
    pkgs.freetube
    pkgs.qbittorrent
    pkgs.calibre
    pkgs.elixir-ls
    pkgs.gleam
    pkgs.erlang
    pkgs.rebar3
    pkgs.zed-editor
    pkgs.inotify-tools
    pkgs.swaybg
    pkgs.btop
    pkgs.wine
    pkgs.tree
    pkgs.fd
    pkgs.jq
    pkgs.bat
    pkgs.liferea
    pkgs.hyprland
    pkgs.kdePackages.dolphin
    pkgs.cargo
    pkgs.rustc
    pkgs.gcc
    pkgs.hyprpaper
    pkgs.zig_0_15
    pkgs.elixir
    pkgs.file
    pkgs.unzip
    pkgs.nix-output-monitor
    pkgs.ripgrep

    # Themes
    pkgs.adwaita-qt
    pkgs.gnome-themes-extra
    pkgs.gsettings-desktop-schemas
  ];

  wayland.windowManager.hyprland.enable = true;
  services.hyprpaper.enable = true;

  systemd.user.services = {
    waybar = {
      Unit = {
        Description = "Waybar status bar";
        After = ["niri.service"];
        PartOf = ["niri.service"];
      };
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["niri.service"];
      };
    };

    hyprpaper = {
      Unit = {
        # Description = "Hyprpaper wallpaper background";
        After = ["hyprland-session.target"];
        PartOf = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        # Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };

    swaybg-random = {
      Unit = {
        Description = "swaybg wallpaper background";
        After = ["niri.service"];
        PartOf = ["niri.service"];
      };
      Service = {
        ExecStart = "%h/.local/bin/swaybg-random-wallpaper.sh";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["niri.service"];
      };
    };

    hyprpaper-random = {
      Unit = {
        Description = "hyprpaper random wallpaper background";
        After = ["hyprpaper.service"];
        PartOf = ["hyprpaper.service"];
      };
      Service = {
        ExecStart = "%h/.local/bin/random-wallpaper/hyprpaper/hyprpaper-random-wallpaper.sh";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprpaper.service"];
      };
    };
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
    platformTheme.name = "gtk3"; # This helps Qt apps follow GTK theme
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".config/niri/".source = ./dotfiles/niri;
    ".config/nvim-fzf/config".text = ''
      [roots]
      $HOME/.config/nixos
      $HOME/.config
      $HOME/projects
      $HOME/notes
      $HOME/.local/bin

      [ignore]
      .git
      node_modules
      target
      .direnv

    '';
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    PAGER = "bat";
  };

  programs.home-manager.enable = true;
}
