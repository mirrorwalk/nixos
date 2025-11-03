{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.imageVideo.mpv;

  mpvWrap =
    (inputs.wrappers.wrapperModules.mpv.apply {
      inherit pkgs;
    }).wrapper;
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
    home.packages = [mpvWrap];

    systemConfig.defaults.video.desktopName = lib.mkIf cfg.default.video "mpv.desktop";
    systemConfig.defaults.image.desktopName = lib.mkIf cfg.default.image "mpv.desktop";
    systemConfig.defaults.audio.desktopName = lib.mkIf cfg.default.audio "mpv.desktop";
  };
}
