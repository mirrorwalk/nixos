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
    pkgs.wine
    pkgs.nix-index
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
    pkgs.clipman
    pkgs.python314
    pkgs.zls
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
        vi = "nvim";
        vim = "nvim";

        enix = "nvim $HOME/.config/nixos";
    };

    initContent = ''
        rebuildNixOS() {
            cd "$HOME/.config/nixos"

            git add .
            git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
            git push

            sudo nixos-rebuild switch --flake $HOME/.config/nixos#desktop
        }

        git_branch() {
            git branch 2>/dev/null | grep '^*' | colrm 1 2
        }
            
        setopt PROMPT_SUBST
        PS1=$'\e[36m[\e[33m%n\e[32m@\e[34m%m \e[35m%~\e[36m]\e[31m$(git_branch)\e[0m$ '

        export LC_CTYPE=en_US.UTF-8
        unset LC_ALL

        eval "$(direnv hook zsh)"
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
