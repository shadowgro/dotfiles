{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.joplin-desktop
    pkgs.joplin-cli
  ];

  nixpkgs.overlays = [
    (final: prev: {
      joplin-desktop = final.runCommand
          "joplin-desktop-${prev.joplin-desktop.version}-patched"
          {
            nativeBuildInputs = [
              final.asar
              final.inkscape
              final.python3
              final.findutils
              final.gnugrep
              final.gnused
            ];

            meta = prev.joplin-desktop.meta;
          }
          ''
           set -euo pipefail
           cp -a ${prev.joplin-desktop}/. "$out/"
           chmod -R u+w "$out"

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
           # ----------------------------------------------------------

           icons_dir="$(dirname "$app_asar")/build/icons"

           if [ ! -d "$icons_dir" ]; then
             echo "ERROR: Joplin icons directory not found:"
             echo "       $icons_dir"
             exit 1
           fi

           echo "Replacing Joplin tray icons..."

           ${pkgs.inkscape}/bin/inkscape \
             ${pkgs.yamis}/apps/scalable/joplin.svg \
             --export-filename="$icons_dir/16x16.png" \
             --export-width=16 \
             --export-height=16

           ${pkgs.inkscape}/bin/inkscape \
             ${pkgs.yamis}/apps/scalable/joplin.svg \
             --export-filename="$icons_dir/16x16@2x.png" \
             --export-width=32 \
             --export-height=32

           ${pkgs.inkscape}/bin/inkscape \
             ${pkgs.yamis}/apps/scalable/joplin.svg \
             --export-filename="$icons_dir/16x16@3x.png" \
             --export-width=48 \
             --export-height=48

           ${pkgs.inkscape}/bin/inkscape \
             ${pkgs.yamis}/apps/scalable/joplin.svg \
             --export-filename="$icons_dir/128x128.png" \
             --export-width=128 \
             --export-height=128

           echo "Joplin tray icons replaced."

           find "$out" -type f \
                   -exec grep -IlF '${prev.joplin-desktop}' {} + |
                   while IFS= read -r file; do
                     sed -i \
                       "s|${prev.joplin-desktop}|$out|g" \
                       "$file"
                   done
         '';
    })
  ];
}
