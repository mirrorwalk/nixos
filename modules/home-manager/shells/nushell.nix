{
  lib,
  config,
  ...
}: {
  options.shells.nu.enable = lib.mkEnableOption "Enable nushell";
  config = lib.mkIf config.shells.nu.enable {
    programs.nushell = {
      enable = true;
      shellAliases = lib.mkForce {};
    };
  };
}
