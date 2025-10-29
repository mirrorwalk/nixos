{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  options.browsers.librewolf.enable = lib.mkEnableOption "Enables librewolf";

  config = lib.mkIf config.browsers.librewolf.enable {
    programs.librewolf = {
      enable = true;
      profiles.default = {
        bookmarks = config.browsers.firefox.bookmarks;
        extensions = config.browsers.firefox.extensions;
        search = {
          force = true;
          default = config.browsers.search.defaultEngine;
          privateDefault = config.browsers.search.private.defaultEngine;
            # if config.browsers.search.private.same
            # then config.browsers.search.defaultEngine
            # else config.browsers.search.private.defaultEngine;
          engines = config.browsers.search.engines;
        };
      };
    };
  };
}
