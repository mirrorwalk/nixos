{inputs, ...}: let
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
          }
        ];
      }
    ];
  };
in {
  imports = [
    # (import ./zen.nix {inherit bookmarks;})
    ./zen.nix
    (import ./librewolf.nix {inherit bookmarks;})
  ];
}
