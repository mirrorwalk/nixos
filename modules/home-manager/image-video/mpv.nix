{
  lib,
  config,
  ...
}: let
  cfg = config.imageVideo.mpv;
in {
  options.imageVideo.mpv = {
    enable = lib.mkEnableOption "";
    default = {
      video = lib.mkEnableOption "";
      image = lib.mkEnableOption "";
      audio = lib.mkEnableOption "";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
    };

    systemConfig.default.video.desktopName = lib.mkIf cfg.default.video "mpv.desktop";
    systemConfig.default.image.desktopName = lib.mkIf cfg.default.image "mpv.desktop";
    systemConfig.default.audio.desktopName = lib.mkIf cfg.default.image "mpv.desktop";
  };
}
