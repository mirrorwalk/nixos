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
      rnos = "${pkgs.nh}/bin/nh os switch";
      nosr = "${pkgs.nh}/bin/nh os switch";
      nr = "${pkgs.nh}/bin/nh os switch";
      nt = "${pkgs.nh}/bin/nh os test";
      rn = "${pkgs.nh}/bin/nh os switch";
      ns = "${pkgs.nh}/bin/nh os switch";
      nos = "${pkgs.nh}/bin/nh os switch";
    };
  };
}
