{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    nil
    nixd
  ];

  home-manager.users.kirill = { config, ... }: {
    xdg.configFile = {
      "zed/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/zed/settings.json";
      "zed/keymap.json".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/zed/keymap.json";
    };
  };
}
