{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.gitlab;
in {
  options.services.gitlab = {
    enable = lib.mkEnableOption "Enable gitlab";

    ssh = {
      enable = lib.mkEnableOption "Enable ssh for gitlab";

      file = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "~/.ssh/git";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.glab
    ];

    programs.ssh.matchBlocks = lib.mkIf cfg.ssh.enable {
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = cfg.ssh.file;
      };
    };
  };
}
