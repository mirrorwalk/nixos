{pkgs, ...}: let
  backup-git = pkgs.writeShellScriptBin "backup-git" ''
    ${builtins.readFile ./backup-git.sh}
  '';

in {
    home.packages = [
        backup-git
    ];
}
