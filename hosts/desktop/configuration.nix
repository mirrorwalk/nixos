# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/default.nix
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/brog/.config/sops/age/keys.txt";

  sops.secrets.example-key = {
    owner = config.users.users.brog.name;
  };

  environment.systemPackages = with pkgs; [
    wine
  ];

  plymouth.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.graphics = {
    enable = true;
  };

  services.sshd.enable = true;

  games.enable = true;

  displayManager.ly = {
    enable = true;
    animate = {
      enable = true;
      animation = "doom";
    };
  };

  tor = {
    enable = true;
    snowflake.enable = true;
  };

  autousb.enable = true;

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs;
    [
      orbitron
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  networking.hostName = "desktop";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    mullvad-vpn.enable = true;

    xserver = {
      xkb = {
        layout = "us";
        variant = "dvp";
        options = "caps:escape";
      };

      videoDrivers = ["amdgpu"];
    };

    pipewire.enable = true;

    qbittorrent.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libglvnd
        xorg.libXmu
        xorg.libX11
        xorg.libXext
        xorg.libSM
        xorg.libICE
        xorg.libXrender
        xorg.libXfixes
        xorg.libXi
        SDL2
        mesa
        pulseaudio
        pipewire
        pkgsi686Linux.libglvnd
        pkgsi686Linux.xorg.libX11
        pkgsi686Linux.xorg.libXext
        pkgsi686Linux.xorg.libXrender
        pkgsi686Linux.xorg.libXfixes
        pkgsi686Linux.xorg.libXi
        pkgsi686Linux.SDL2
        pkgsi686Linux.mesa
      ];
    };

    hyprland.enable = true;

    bash.enable = true;
  };

  users.users.brog = {
    isNormalUser = true;
    description = "brog";
    extraGroups = ["networkmanager" "wheel" "qbittorrent"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "brog" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
