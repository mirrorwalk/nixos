{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  options.browsers = {
    allowedCookies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    adblock = {
      enable = lib.mkEnableOption "Enable adblock extensions";
      provider = lib.mkOption {
        type = lib.types.enum ["ublock" "adnauseam"];
      };
    };

    search = {
      defaultEngine = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "ddg";
        description = "default search engine";
      };

      private = {
        defaultEngine = lib.mkOption {
          type = lib.types.str;
          default = config.browsers.search.defaultEngine;
          description = "default private search engine";
        };
      };

      engines = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            urls = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  template = lib.mkOption {
                    type = lib.types.str;
                  };

                  params = lib.mkOption {
                    type = lib.types.listOf (lib.types.submodule {
                      options = {
                        name = lib.mkOption {
                          type = lib.types.str;
                        };

                        value = lib.mkOption {
                          type = lib.types.str;
                        };
                      };
                    });

                    default = [];
                  };
                };
              });
              default = [];
            };

            definedAliases = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
            };

            metaData = lib.mkOption {
              type = lib.types.attrs;
              default = {};
            };
          };
        });
      };
    };

    default = {
      associations = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "text/plain"
          "text/html"
        ];
      };

      browser = {
        desktopName = lib.mkOption {
          type = lib.types.nonEmptyStr;
        };
      };
    };
  };

  config = {
    browsers = {
      search = {
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
          SearchNixOS = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = ["@sno"];
          };

          perplexity.metaData.alias = "@p";
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
        };
      };

      allowedCookies = [
        "https://proton.me"
        "https://youtube.com"
        "https://github.com"
        "https://gitlab.com"
        "https://nano-gpt.com"
        "https://perplexity.ai"
        "https://unicornuniversity.net"
        "https://excalidraw.com"
        "https://spotify.com"
        "https://gog.com"
      ];

      gecko = lib.mkIf config.browsers.adblock.enable {
        extensions = let
          ublock = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}.ublock-origin;
          adnauseam = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}.adnauseam;

          acfg = config.browsers.adblock.provider;

          pckgs =
            if acfg == "ublock"
            then [ublock]
            else if acfg == "adnauseam"
            then [adnauseam]
            else [];
        in {
          packages = pckgs;
        };
      };
    };
  };
}
