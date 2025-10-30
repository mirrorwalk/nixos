{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  options.browsers = {
    firefox = {
      extensions = lib.mkOption {
        description = "Firefox Extensions";
        type = lib.types.attrs;
        default = {
          force = true;
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            ublock-origin
            proton-pass
            sponsorblock
            return-youtube-dislikes
            dearrow
            kagi-search
          ];
        };
      };

      bookmarks = {
        force = lib.mkOption {
          default = true;
          type = lib.types.bool;
        };
        settings = lib.mkOption {
          description = "Firefox bookmarks";
          type = lib.types.listOf lib.types.attrs;
        };
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
        enable = lib.mkEnableOption "Enable default browser";
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

          perplexity.metaData.alias = "@p";
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
        };
      };

      firefox.bookmarks.settings = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "Programming";
              bookmarks = [
                {
                  name = "Zig Docs";
                  url = "https://ziglang.org/documentation/";
                  tags = ["wiki" "zig" "programming"];
                }
                {
                  name = "jujutsu";
                  url = "https://jj-vcs.github.io/jj/latest/";
                  tags = ["wiki" "guide" "git" "jj" "programming"];
                }
              ];
            }
            {
              name = "Nano Gpt";
              url = "https://nano-gpt.com/conversation/new";
              tags = ["ai"];
            }
            {
              name = "NixOS";
              bookmarks = [
                {
                  name = "Nixpkgs Search";
                  url = "https://search.nixos.org";
                  tags = ["nix"];
                }
                {
                  name = "My NixOS";
                  url = "https://mynixos.com/";
                  tags = ["nix"];
                }
                {
                  name = "Home Manager Options";
                  url = "https://home-manager-options.extranix.com/";
                  tags = ["nix"];
                }
              ];
            }
          ];
        }
      ];
    };

    xdg = lib.mkIf config.browsers.default.browser.enable {
      mimeApps = let
        value = config.browsers.default.browser.desktopName;
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          })
          config.browsers.default.associations);
      in {
        defaultApplications = associations;
      };
    };
  };
}
