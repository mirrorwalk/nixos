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
      ];
    };

    # xdg.mimeApps = let
    #   default = config.systemConfig.default.webBrowser;
    #   value = default.desktopName;
    #   associations = builtins.listToAttrs (map (name: {
    #       inherit name value;
    #     })
    #     default.associations);
    # in {
    #   defaultApplications = associations;
    # };

    # xdg = lib.mkIf config.browsers.default.browser.enable {
    #   mimeApps = let
    #     value = config.browsers.default.browser.desktopName;
    #     associations = builtins.listToAttrs (map (name: {
    #         inherit name value;
    #       })
    #       config.browsers.default.associations);
    #   in {
    #     defaultApplications = associations;
    #   };
    # };
  };
}
