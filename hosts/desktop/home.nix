{ config, pkgs, ... }:

{
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ghostty
    pkgs.tmux
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
    pkgs.waybar
    pkgs.keepassxc
    pkgs.mpv
    pkgs.brave
    pkgs.steam
    pkgs.direnv
    pkgs.hyprcursor
    pkgs.fuzzel
    pkgs.xwayland-satellite
    pkgs.cryptsetup
    pkgs.wl-clipboard
    pkgs.python314
    pkgs.zls
    pkgs.jujutsu
    pkgs.vscode-fhs
    pkgs.nodejs_24
    pkgs.gh
    pkgs.freetube
    pkgs.qbittorrent
    pkgs.calibre
    pkgs.elixir-ls
    pkgs.gleam
    pkgs.erlang
    pkgs.rebar3
    pkgs.qutebrowser
    pkgs.kiwix
    pkgs.zed-editor
    pkgs.inotify-tools
    pkgs.swaybg
    pkgs.digikam
  ];

systemd.user.services = {
    waybar = {
      Unit = {
        Description = "Waybar status bar";
        After = [ "niri.service" ];
        PartOf = [ "niri.service" ];
      };
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "niri.service" ];
      };
    };

    swaybg = {
      Unit = {
        Description = "swaybg wallpaper background";
        After = [ "niri.service" ];
        PartOf = [ "niri.service" ];
      };
      Service = {
        ExecStart = "%h/bin/random-wallpaper.sh";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "niri.service" ];
      };
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
      };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
        vi = "nvim";
        vim = "nvim";

        enix = "cd $HOME/.config/nixos && nvim $HOME/.config/nixos";
    };

    initContent = ''
        rebuildNixOS() {
            cd "$HOME/.config/nixos" || {
                echo "Could not find $HOME/.config/nixos"
                    return 1
            }

            if [[ -z $(git status --porcelain) ]]; then
                echo "No configuration changes — skipping rebuild."
                    return 0
            fi

            echo "Building new NixOS configuration (test build)..."
            if nixos-rebuild build --flake "$HOME/.config/nixos#desktop"; then
                echo "Build succeeded. Committing changes..."
                    git add .
                    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
                    git push

                    echo "Activating committed configuration..."
                    sudo nixos-rebuild switch --flake "$HOME/.config/nixos#desktop"
                    echo "Rebuild complete."
            else
                echo "Build failed — no commit made."
                    return 1
            fi
        }
        nvimcd() {
            if [[ -d $1 ]]; then
                cd "$1" || return
                nvim .
            else
                nvim "$@"
            fi
        }

        setopt PROMPT_SUBST
        PS1='%F{cyan}[%F{yellow}%n%F{green}@%F{blue}%m %F{magenta}%~%F{cyan}]%F{red}$(git branch --show-current 2>/dev/null | sed "s/.*/(&)/")%f$ '
            
        eval "$(direnv hook zsh)"

        autoload -U compinit
        compinit
        source <(jj util completion zsh)
    '';

  };

  programs.git = {
    enable = true;
    userName = "mirrorwalk";
    userEmail = "git.cresting327@passmail.net";

    extraConfig = {
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "master";
      };
    };

    delta = {
      enable = true;
      options = {
        navigate = true; # Enable navigation in large diffs
        light = false; # Set to true for light themes
        line-numbers = true;
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brog/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  	EDITOR="nvim";
    VISUAL="nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
