{
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  home-manager.users.kirill = { config, ... }: {
    xdg.configFile = {
      "hypr/hyprland.lua".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/hyprland/hyprland.lua";

      "hypr/config".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/hyprland/config";

    };

    wayland.windowManager.hyprland.systemd.enable = false;

  };
}
