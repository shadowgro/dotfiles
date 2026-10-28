{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      yamis = final.stdenv.mkDerivation {
        pname = "yamis";
        version = inputs.yet-another-monochrome-icon-set.lastModifiedDate;
        src = inputs.yet-another-monochrome-icon-set;
        installPhase = ''
          mkdir -p $out
          cp -r . $out/

          ln -s \
            $out/apps/scalable/hdspmixer.svg \
            $out/apps/scalable/com.saivert.pwvucontrol.svg

          ln -s \
            $out/apps/scalable/joplin.svg \
            $out/apps/scalable/appimagekit-joplin.svg

          rm -r \
            $out/places/scalable

          mv \
            $out/places/scalable-outlined \
            $out/places/scalable

          rm -r \
            $out/mimetypes/scalable

          mv \
            $out/mimetypes/scalable-outlined \
            $out/mimetypes/scalable
        '';
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    yamis
    papirus-icon-theme
    kdePackages.breeze-icons
  ];

  home-manager.users.kirill.home.file.".local/share/icons/yet-another-monochrome-icon-set".source = pkgs.yamis;
}
