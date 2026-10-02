{ ... }:

{
  programs.mango.enable = true;

  home-manager.users.kirill = { config, ... }: {
    xdg.configFile."mango/config.conf".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/mango/config.conf";
  };
}
