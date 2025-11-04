{
  imports = [
    ./browsers-config.nix
    ./gecko/gecko-config.nix
    ./gecko/zen-browser/zen.nix
    ./gecko/librewolf.nix
    ./gecko/firefox.nix
    ./gecko/mullvad.nix
    ./gecko/tor.nix
    ./chromium/brave.nix
    ./chromium/chromium.nix
  ];
}
