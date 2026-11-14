{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      wine-d2d1 = prev.wineWow64Packages.stable.overrideAttrs (old: {
        pname = "wine-d2d1";
        version = "11.0-d2d1";
        src = inputs.wine-d2d1-src;
      });
    })
  ];
}
