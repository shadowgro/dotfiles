{ ... }:

{
  programs.amnezia-vpn.enable = true;

  # chandge icon
  home-manager.users.kirill.home.file = {
    ".local/share/applications/AmneziaVPN.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=AmneziaVPN
        Version=1.0
        Comment=Client of your self-hosted VPN
        Exec=AmneziaVPN
        Icon=AmneziaVPN
        Categories=Network;Qt;Security;
        Terminal=false
      '';
  };
}
