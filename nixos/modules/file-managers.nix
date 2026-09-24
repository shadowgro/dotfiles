{ pkgs, ... }:
{
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    udisks2.enable = true; # for auto-mount and other stuff
  };

  programs = {
    xfconf.enable = true; # for thunar
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
        thunar-volman
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    lxqt.pcmanfm-qt
    lxqt.libfm-qt
    lxqt.lxqt-menu-data
    ffmpegthumbnailer
    file-roller
    xarchiver
    ntfs3g # flash-drive care
    kdePackages.plasma-integration # for qt apps
  ];

  nixpkgs.overlays = [
    (final: prev: {
      lxqt = prev.lxqt // {
        pcmanfm-qt = prev.lxqt.pcmanfm-qt.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            ./patches/pcmanfm-qt-hide-toolbar-actions.patch
          ];
        });
      };
    })
  ];


}
