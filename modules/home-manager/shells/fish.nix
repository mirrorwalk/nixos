{
  lib,
  config,
  ...
}: {
  options = {
    shells.fish.enable = lib.mkEnableOption "Enable fish shell";
  };

  config = lib.mkIf config.shells.fish.enable {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
      };
    };
  };
}
