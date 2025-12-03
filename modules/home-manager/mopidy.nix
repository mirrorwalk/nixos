{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mopidy;
in {
  options.mopidy = {
    enable = lib.mkEnableOption "";
    spotify.enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
    sops = lib.mkIf cfg.spotify.enable {
      secrets = {
        mopidy_spotify_client_id = {};
        mopidy_spotify_client_secret = {};
      };

      templates."mopidy-spotify.conf".content = ''
        [spotify]
        client_id = ${config.sops.placeholder.mopidy_spotify_client_id}
        client_secret = ${config.sops.placeholder.mopidy_spotify_client_secret}
      '';
    };

    services.mopidy = {
      enable = true;

      extensionPackages = with pkgs;
        [
          mopidy-mpd
          mopidy-local
        ]
        ++ lib.optionals cfg.spotify.enable [pkgs.mopidy-spotify];
      settings = {
        file = {
          enabled = true;
          media_dirs = [
            "~/Music|Music"
          ];
        };

        local = {
          enabled = true;
          media_dir = "~/Music";
        };

        mpd = {
          enabled = true;
        };
      };

      extraConfigFiles = lib.mkIf cfg.spotify.enable [
        config.sops.templates."mopidy-spotify.conf".path
      ];
    };
  };
}
