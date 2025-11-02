{
  lib,
  config,
  ...
}: let
  cfg = config.services.github;
in {
  options.services.github = {
    enable = lib.mkEnableOption "Enable github";

    ssh = {
      enable = lib.mkEnableOption "Enable ssh for github";

      file = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "~/.ssh/git";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh.enable = true;

    programs.ssh.matchBlocks = lib.mkIf cfg.ssh.enable {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = cfg.ssh.file;
      };
    };
  };
}
