{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [

    wineWow64Packages.stable
    winetricks

    keepassxc
    alarm-clock-applet
    # libreoffice-qt
    qbittorrent
    vlc
    inkscape
    tor-browser
    yandex-disk
    telegram-desktop

    yazi
    fzf
    btop
    bat
    git
    # hashdeep
    hyprpicker
    ntfs3g # flash-drive care
  ];

}
