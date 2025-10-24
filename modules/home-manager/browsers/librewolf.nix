{
  lib,
  config,
  ...
}: {
  options = {
    browser.librewolf.enable = lib.mkEnableOption "Enables librewolf";
  };
  config =
    lib.mkIf config.browser.librewolf.enable {
        programs.librewolf = {
            enable = true;
        };
    };
}
