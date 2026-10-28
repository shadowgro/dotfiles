{ pkgs, ... }:
{
  # imports = [
  #   inputs.noctalia.nixosModules.default
  # ];

  programs.noctalia.enable = true;

  services.xserver.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 36;
      keyboard = {
        layout = "us";
        numlock = true;
      };
      appearance = {
        hide_logo = true;
        # wallpaper = {
        #   path = "/var/lib/noctalia-greeter/blurred-image.png";
        #   fill_mode = "crop"; # center | crop | fit | stretch | repeat
        # };
      };
    };
    cursorTheme = {
      package = pkgs.bibata-cursors-translucent;
      name = "Bibata_Ghost";
    };
  };

  home-manager.users.kirill = { config, ... }: {
    home.file = {
      ".local/state/noctalia/settings.toml".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/noctalia/settings.toml";
      ".config/noctalia/palettes".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/noctalia/palettes";
    };
  };
}
