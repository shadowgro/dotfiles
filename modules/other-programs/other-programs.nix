{ pkgs, stable, inputs, ... }:

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
    yazi
    superfile
    fzf
    eza
    btop
    bat
    git
    github-cli
    dix
    ntfs3g # flash-drive care
    timr-tui
    tealdeer
    stable.yandex-disk
    # hashdeep
    inputs.rom.packages.${stdenv.hostPlatform.system}.default

    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
