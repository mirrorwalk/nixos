{
  pkgs,
  lib,
  config,
  ...
}: let
  value = "mullvad-browser.desktop";
  associations = builtins.listToAttrs (map (name: {
      inherit name value;
    })
    config.browsers.defaultAssociations);
in {
  options.browsers.mullvad = {
    enable = lib.mkEnableOption "Enable mullvad browser";
    defaultBrowser = lib.mkEnableOption "Mullvad as default browser";
  };

  config = lib.mkIf config.browsers.mullvad.enable {
    home.packages = [
      pkgs.mullvad-browser
    ];

    xdg.mimeApps = lib.mkIf config.browsers.mullvad.defaultBrowser {
      defaultApplications = associations;
    };
  };
}
