{config, ...}: {
  imports = [
    ../../nixos/desktop-variables/variables.nix
  ];
  programs.cava = {
    enable = true;
    settings = {
      color = {
        background = "'${config.colorScheme.background}'";
        foreground = "'${config.colorScheme.primary}'";
      };
    };
  };
}
