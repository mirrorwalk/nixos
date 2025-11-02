{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.styleConfig = {
    defaultWallpaper = mkOption {
      type = types.path;
      description = "The default wallpaper to load";
    };
    wallpaperFolders = mkOption {
      type = types.listOf types.path;
      description = "Folders where to take wallpapers from";
    };
  };
}
