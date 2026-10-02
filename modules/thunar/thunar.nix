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
    ffmpegthumbnailer
    file-roller
  ];
  home-manager.users.kirill = {
      xdg.configFile."Thunar/uca.xml".source = ./uca.xml;
  };
}
