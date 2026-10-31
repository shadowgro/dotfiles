{ pkgs, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [

    # wineWow64Packages.stable
    wine-d2d1
    winetricks

    keepassxc
    # libreoffice-qt
    qbittorrent
    mpv
    inkscape
    tor-browser
    telegram-desktop
    hyprpicker

    #CLI
    yazi
    superfile
    fzf
    television
    fd
    btop
    bat
    git
    github-cli
    nix-search-tv
    ntfs3g # flash-drive care
    cliamp
    timr-tui
    tealdeer
    yandex-disk
    # hashdeep
  ];
}
