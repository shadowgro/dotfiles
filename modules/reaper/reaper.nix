{ pkgs, stable, ... }:

{
  home-manager.users.kirill = { config, ... }: {
    home.file = {
      # ".config/REAPER".source =
      #   config.lib.file.mkOutOfStoreSymlink
      #     "${config.home.homeDirectory}/.dotfiles/modules/reaper/REAPER";

      ".wine/drive_c/users/kirill/AppData/Roaming/REAPER".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/reaper/REAPER";

      ".config/REAPER" = {
        source = pkgs.symlinkJoin {
          name = "reaper-userplugins";
          paths = [
            stable.reaper-sws-extension
            stable.reaper-reapack-extension
          ];
        };
        recursive = true;
      };

      ".local/share/applications/REAPER(WINE).desktop".text = ''
          [Desktop Entry]
          Name=REAPER (WINE)
          Exec=env WINEPREFIX=/home/kirill/.wine nvidia-offload wine "/home/kirill/.wine/drive_c/Program Files/REAPER (x64)/reaper.exe"
          Type=Application
          StartupNotify=true
          Path=/home/kirill/.wine/drive_c/ProgramData/Microsoft/Windows/Start Menu/Programs/REAPER (x64)
          Icon=cockos-reaper
          StartupWMClass=reaper.exe
        '';
    };

    # home.activation = {
    #   linkReaperPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     TARGET_DIR="/home/kirill/.dotfiles/modules/reaper/REAPER/UserPlugins"
    #     mkdir -p "$TARGET_DIR"
    #     ln -sf "${pkgs.reaper-reapack-extension}/UserPlugins/reaper_reapack-x86_64.so" "$TARGET_DIR/"
    #     ln -sf "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-x86_64.so" "$TARGET_DIR/"
    #   '';
    # };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    stable.reaper
    # reaper-sws-extension
    # reaper-reapack-extension
    stable.yabridge
    stable.yabridgectl

    # (pkgs.symlinkJoin {
    #   name = "reaper-nvidia-gtk";
    #   paths = [
    #     pkgs.reaper
    #     (pkgs.writeShellScriptBin "reaper" ''
    #       export LD_LIBRARY_PATH="${lib.makeLibraryPath [ pkgs.gtk3 ]}:''${LD_LIBRARY_PATH:-}"
    #       export XDG_DATA_DIRS="${pkgs.gtk3}/share:${pkgs.gnome-themes-extra}/share:${pkgs.adwaita-icon-theme}/share:''${XDG_DATA_DIRS:-}"
    #       exec /run/current-system/sw/bin/nvidia-offload ${pkgs.reaper}/bin/reaper "$@"
    #     '')
    #   ];
    # })
#
#
#     (pkgs.symlinkJoin {
#       name = "reaper-with-gtk";
#       paths = [ pkgs.reaper ];
#       buildInputs = [ pkgs.makeWrapper ];
#       postBuild = ''
#         wrapProgram $out/bin/reaper \
#           --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.gtk3 ]}" \
#           --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share:${pkgs.gnome-themes-extra}/share:${pkgs.adwaita-icon-theme}/share" \
#           --set GTK_THEME "Adwaita:dark"
#       '';
#     })

  ];
}
