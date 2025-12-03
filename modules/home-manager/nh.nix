{
  lib,
  config,
  pkgs,
  ...
}: {

  config = lib.mkIf config.programs.nh.enable {
    programs.nh = {
      flake = "/home/brog/.config/nixos";
    };

    home.shellAliases = {
      nr = "${pkgs.nh}/bin/nh os switch";
      nb = "${pkgs.nh}/bin/nh os build";
      nt = "${pkgs.nh}/bin/nh os test";
    };
  };
}
