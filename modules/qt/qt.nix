{ pkgs, ... }:

{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     orchis-kvantum = final.stdenv.mkDerivation {
  #       pname = "orchis-kvantum";
  #       version = orchis-kde.lastModifiedDate;
  #       src = orchis-kde;
  #       installPhase = ''
  #         mkdir -p $out
  #         cp $out/Kvantum/Orchis/OrchisDark.kvconfig $out/
  #         cp $out/Kvantum/Orchis/OrchisDark.svg $out/
  #       '';
  #     };
  #   })
  # ];

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "kvantum";
    # QS_ICON_THEME = "yet-another-monochrome-icon-set";
    # QT_ICON_THEME_PATH = "${pkgs.yamis}";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.plasma-integration # for qt apps
  ];

  home-manager.users.kirill = { config, ... }: {
    qt = {
      enable = true;
      style.name = "kvantum";
      kvantum = {
        enable = true;
        settings.General.theme = "OrchisDark";
      };
    };

    xdg.configFile = {
      "Kvantum/OrchisDark".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/qt/OrchisDark";
      "kdeglobals".source =
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/.dotfiles/modules/qt/kdeglobals";
    };
  };
}
