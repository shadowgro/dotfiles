{ pkgs, ... }:

let
  joplin-custom = pkgs.joplin-desktop.overrideAttrs (old: {
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        pkgs.asar
        pkgs.inkscape
        pkgs.python3
      ];

    postInstall =
      (old.postInstall or "")
      + ''
        set -euo pipefail

        echo "Patching Joplin app.asar..."

        # Find the app.asar installed by the original
        # joplin-desktop package.
        app_asar="$(
          find "$out" \
            -type f \
            -path '*/resources/app.asar' \
            -print -quit
        )"

        if [ -z "$app_asar" ]; then
          echo "ERROR: Joplin app.asar not found"
          exit 1
        fi

        echo "Found: $app_asar"

        # Extract original app.asar.
        app_dir="$TMPDIR/joplin-app"

        rm -rf "$app_dir"
        mkdir -p "$app_dir"

        ${pkgs.asar}/bin/asar extract \
          "$app_asar" \
          "$app_dir"

        # Apply the final working transparency patch.
        ${pkgs.python3}/bin/python3 \
          ${./joplin-patch.py} \
          "$app_dir"

        # Repack patched app.asar.
        rm "$app_asar"

        ${pkgs.asar}/bin/asar pack \
          "$app_dir" \
          "$app_asar"

        echo "Joplin app.asar patched."

        # ----------------------------------------------------------
        # Tray icons
        #
        # 16x16@2x.png -> 32x32
        # 16x16@3x.png -> 48x48
        # ----------------------------------------------------------

        icons_dir="$(dirname "$app_asar")/build/icons"

        if [ ! -d "$icons_dir" ]; then
          echo "ERROR: Joplin icons directory not found:"
          echo "       $icons_dir"
          exit 1
        fi

        echo "Replacing Joplin tray icons..."

        ${pkgs.inkscape}/bin/inkscape \
          ${./joplin.svg} \
          --export-filename="$icons_dir/16x16@2x.png" \
          --export-width=32 \
          --export-height=32

        ${pkgs.inkscape}/bin/inkscape \
          ${./joplin.svg} \
          --export-filename="$icons_dir/16x16@3x.png" \
          --export-width=48 \
          --export-height=48

        echo "Joplin tray icons replaced."
      '';
  });
in
{
  home.packages = [
    joplin-custom
  ];
}
