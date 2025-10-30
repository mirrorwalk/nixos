{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nom.enable = lib.mkEnableOption "Enable nom";

  config = lib.mkIf config.nom.enable {
    home.packages = [
      pkgs.nix-output-monitor
    ];

    home.shellAliases = {
      nix-shell = "${pkgs.nix-output-monitor}/bin/nom-shell";
      nix-build = "${pkgs.nix-output-monitor}/bin/nom-build";
      nix = "${pkgs.nix-output-monitor}/bin/nom";
      nd = "${pkgs.nix-output-monitor}/bin/nom develop";
    };
  };
}
