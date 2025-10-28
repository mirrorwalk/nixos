{
  lib,
  inputs,
  pkgs,
  ...
}: {
  options = {
    browsers.firefox-extensions = lib.mkOption {
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
    browsers.firefox-bookmarks = {
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
  config = {
    # browsers.firefox-bookmarks.base-bookmarks = [
    browsers.firefox-bookmarks.settings = [
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
            ];
          }
        ];
      }
    ];
  };
}
