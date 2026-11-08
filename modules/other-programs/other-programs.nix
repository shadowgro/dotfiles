{ pkgs, stable, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [

    wineWow64Packages.stable
    # wine-d2d1
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
    nh
    yazi
    superfile
    fzf
    # television
    fd
    eza
    btop
    dysk
    bat
    git
    github-cli
    # nix-search-tv
    # nix-output-monitor
    # dix
    ntfs3g # flash-drive care
    cliamp
    timr-tui
    tealdeer
    stable.yandex-disk
    # hashdeep
  ];
}
