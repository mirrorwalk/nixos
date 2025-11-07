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

  sops.defaultSopsFile = ./secrets/secrets.json;
  sops.defaultSopsFormat = "json";

  sops.age.keyFile = "/home/brog/.config/sops/age/keys.txt";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  plymouth.enable = true;

  autousb.enable = true;

  displayManager.ly = {
    enable = true;
  };

  keyring.gnome.enable = true;

  programs = {
    nix-ld.enable = true;

    hyprland.enable = true;

    bash.enable = true;
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs;
      [
        orbitron
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  wifi.enable = true;

  networking = {
    hostName = "zentop";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };

  users.users.brog = {
    isNormalUser = true;
    description = "brog";
    extraGroups = ["networkmanager" "wheel"];
  };

  services = {
    mullvad-vpn.enable = true;

    logind.settings.Login = {
      HandlePowerKey = "ignore";
    };

    xserver.xkb = {
      layout = "us";
      variant = "dvp";
    };

    pipewire.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "brog" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
