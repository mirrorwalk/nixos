let
  bookmarks = {
    force = true;
    settings = [
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
                name = "Search NixOS";
                url = "search.nixos.org";
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
in {
  imports = [
    (import ./zen.nix {inherit bookmarks;})
    (import ./librewolf.nix {inherit bookmarks;})
  ];
}
