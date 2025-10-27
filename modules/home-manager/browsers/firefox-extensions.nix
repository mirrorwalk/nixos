{pkgs, inputs, ...}: {
  firefox-extensions = {
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
}
