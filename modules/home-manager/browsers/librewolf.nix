{bookmarks}: {
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  options = {
    browsers.librewolf.enable = lib.mkEnableOption "Enables librewolf";
  };
  config = lib.mkIf config.browsers.librewolf.enable {
    programs.librewolf = {
      enable = true;
      profiles.default = {
        inherit bookmarks;
        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages."x86_64-linux"; [
            ublock-origin
            proton-pass
            sponsorblock
            return-youtube-dislikes
            dearrow
            kagi-search
          ];
        };
        search = {
          force = true;
          default = "Kagi";
          privateDefault = "Kagi";
          engines = {
            Kagi = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@k" "@kagi"];
            };
            google.metaData.hidden = true;
            bing.metaData.hidden = true;
          };
        };
      };
    };
  };
}
