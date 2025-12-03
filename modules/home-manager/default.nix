{
  inputs,
  lib,
  ...
}: let
  hmm = [
    ./bat.nix
    ./browsers/browsers.nix
    ./cava.nix
    ./fuzzel.nix
    ./hypr/hypr.nix
    ./nh.nix
    ./nom.nix
    ./nvim.nix
    ./shells/shells.nix
    ./terminals/terminals.nix
    ./waybar.nix
    ./version-control/vc.nix
    ./file-managers/fm.nix
    ./image-video/iv.nix
    ./udiskie.nix
    ./brightness.nix
    ./notifications/notifications.nix
    ./games.nix
    ./nm-applet.nix
    ./desktops/desktops.nix
    ./mopidy.nix
  ];

  sm = [
    ../system/style/style.nix
    ../system/system/system.nix
  ];

  cm = [
    ../custom/enix/enix.nix
    ../custom/git/git.nix
    ../custom/hyprpaper-random/hyprpaper-random.nix
    ../custom/tmux-startup/tmux-startup.nix
    ../custom/shutdown-menu/shutdown-menu.nix
    ../custom/music.nix
  ];

  im = [
    inputs.nvimFZF.default
  ];

  inherit (lib) mkDefault;
in {
  imports = hmm ++ sm ++ cm ++ im;

  config = mkDefault {
    desktop.hyprland = {
        enable = true;
        pinPIP.enable = true;
    };

    udiskie.enable = true;

    imageVideo.mpv = {
      enable = true;
      default = {
        video = true;
        image = true;
        audio = true;
      };
    };

    fileManagers = {
      thunar = {
        # enable = true;
        # defaultFileManager = true;
      };
      ranger = {
          enable = true;
          defaultFileManager = true;
      };
    };

    systemConfig.defaults = {
      enable = true;
    };

    runners.fuzzel = {
      enable = true;
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

    bars.waybar = {
      enable = true;
      systemService.enable = true;
      hyprland.enable = true;
      mullvadVPN.enable = true;
    };

    browsers = {
      adblock = {
        enable = true;
        provider = "adnauseam";
      };
    };

    programs = {
      git = {
        enable = true;
        sign.enable = true;
      };

      jujutsu.enable = true;

      nh.enable = true;
      nom.enable = true;

      neovim.enable = true;

      fzf.enable = true;

      jq.enable = true;
      fd.enable = true;
      btop.enable = true;
      ripgrep.enable = true;
    };

    notif.mako.enable = true;

    services = {
      gitlab = {
        enable = true;
        ssh.enable = true;
      };

      github = {
        enable = true;
        ssh.enable = true;
      };

      setupGitRemotes = {
        enable = true;
      };

      backupGit = {
        enable = true;
      };
    };

    hypr = {
      hyprpaper = {
        enable = true;
      };
      hyprlock = {
        enable = true;
        hyprland = {
          enable = true;
        };
      };
      hyprshot.enable = true;
    };

    terminals = {
      ghostty = {
        enable = true;
        defaultTerminal = true;
      };
    };

    browsers = {
      gecko = {
          picture-in-picture.enable = true;
      };
      zen-browser.enable = true;
    };
  };
}
