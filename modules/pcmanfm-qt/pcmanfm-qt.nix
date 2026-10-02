{ pkgs, ... }:
{
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    udisks2.enable = true; # for auto-mount and other stuff
  };

  environment.systemPackages = with pkgs; [
    lxqt.pcmanfm-qt
    lxqt.libfm-qt
    lxqt.lxqt-menu-data
    ffmpegthumbnailer
    file-roller
    xarchiver
    # kdePackages.plasma-integration # for qt apps
  ];

  nixpkgs.overlays = [
    (final: prev: {
      lxqt = prev.lxqt // {
        pcmanfm-qt = prev.lxqt.pcmanfm-qt.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            ./pcmanfm-qt-hide-toolbar-actions.patch
            ./pcmanfm-qt-context-menu.patch
          ];
        });
      };
    })
  ];

  home-manager.users.kirill = { config, ... }: {
    xdg.configFile."pcmanfm-qt/default/settings.conf".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/pcmanfm-qt/settings.conf";
  };
}
