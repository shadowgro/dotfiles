{ config, pkgs, lib, inputs, ... }:

let
  orchis-kde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "main";
    hash = "sha256-mO1AVrnXNdg3Rftj0cQWef/RrBgSDy5kaMHagwKywEo=";
  };
  
  monochrome-icon-set = pkgs.fetchFromBitbucket {
    owner = "dirn-typo";
    repo = "yet-another-monochrome-icon-set";
    rev = "main";
    hash = "sha256-7CN5G8nYZM9qxFMRyWDIlJC0SjN7SnLQ5RUVaP1y0hc=";
  };

  mkDotfileSymlink = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/${path}";
   
in

{
  
  home.username = "kirill";
  home.homeDirectory = "/home/kirill";

  home.stateVersion = "26.05";

#   imports = [
#     inputs.mango.hmModules.mango
#   ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kitty = {
  	enable = true;
  	settings = {
  		cursor_trail = 1;
  		cursor_trail_decay = "0.1 0.4";
  		cursor_trail_start_threshold = 2;
  		background_opacity = "0.3";
  		font_family = "Maple Mono NF";
  		font_size = "14.0";
  		scrollback_lines = 10000;
  		enable_audio_bell = false;
  		include = "themes/noctalia.conf";
  		confirm_os_window_close = 0;
  	};
  };

  programs.micro = {
  	enable = true;
  	settings = {
  		colorscheme = "simple";
  		history = 100;
  		hlsearch = true;
  		savecursor = true;
  		savehistory = true;
  		scrollspeed = 3;
  		softwrap = true;
  		wordwrap = true;
  	};
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Grey-Dark-Compact";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "yet-another-monochrome-icon-set";
      # package = monochrome-icons;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    kvantum = {
      enable = true;
      settings.General.theme = "OrchisDark";
    };
  };

  
  # home.sessionVariables = { 
    # QT_STYLE_OVERRIDE = "kvantum";
    # XDG_DATA_DIRS = "${monochrome-icons}/share:${config.home.profileDirectory}/share:$XDG_DATA_DIRS";
  #   QS_ICON_THEME = "yet-another-monochrome-icon-set";
  #   QT_ICON_THEME_PATH = "${monochrome-icons}/share/icons";
  # };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors-translucent;
    name = "Bibata_Ghost";
    # size = 36;
    # gtk.enable = true;
    # x11.enable = true;
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    kdePackages.breeze-icons
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum

    # (pkgs.symlinkJoin {
    #   name = "reaper-nvidia";
    #   paths = [
    #     pkgs.reaper
    #     (pkgs.writeShellScriptBin "reaper" ''
    #       export LD_LIBRARY_PATH="${lib.makeLibraryPath [ pkgs.gtk3 ]}:''${LD_LIBRARY_PATH:-}"
    #       export XDG_DATA_DIRS="${pkgs.gtk3}/share:${pkgs.gnome-themes-extra}/share:${pkgs.adwaita-icon-theme}/share:''${XDG_DATA_DIRS:-}"
    # 
    #       exec /run/current-system/sw/bin/nvidia-offload \
    #         ${pkgs.reaper}/bin/reaper "$@"
    #     '')
    #   ];
    # })
    
    
    # (pkgs.symlinkJoin {
    #   name = "reaper-with-gtk";
    #   paths = [ pkgs.reaper ];
    #   buildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/reaper \
    #       --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.gtk3 ]}" \
    #       --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share:${pkgs.gnome-themes-extra}/share:${pkgs.adwaita-icon-theme}/share" \
    #       --set GTK_THEME "Adwaita:dark"
    #   '';
    # })

    # (pkgs.symlinkJoin {
    #   name = "thunar-x11";
    #   paths = [ pkgs.thunar ];
    #   buildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/thunar \
    #       --set GDK_BACKEND x11
    #   '';
    # })
    
  ];

  home.file = {
    ".config/mango/config.conf".source = mkDotfileSymlink "mango/config.conf";
    ".config/micro/bindings.json".source = mkDotfileSymlink "micro/bindings.json";
    ".local/state/noctalia/settings.toml".source = mkDotfileSymlink "noctalia/settings.toml";
    ".config/noctalia/palettes".source = mkDotfileSymlink "noctalia/palettes";
    ".p10k.zsh".source = mkDotfileSymlink "zsh/zsh-powerlevel10k/.p10k.zsh";
    ".config/Thunar/uca.xml".source = mkDotfileSymlink "Thunar/uca.xml";
    ".config/pcmanfm-qt/default/settings.conf".source = mkDotfileSymlink "pcmanfm-qt/settings.conf";
    ".config/REAPER".source = mkDotfileSymlink "reaper_config/REAPER";
    ".wine/drive_c/users/kirill/AppData/Roaming/REAPER".source = mkDotfileSymlink "reaper_config/REAPER";
    ".config/Kvantum/OrchisDark".source = mkDotfileSymlink "themes/Orchis/Kvantum";
    ".local/share/icons/yet-another-monochrome-icon-set".source = mkDotfileSymlink "icons/yet-another-monochrome-icon-set";
    ".config/fastfetch".source = mkDotfileSymlink "fastfetch";
      
    ".config/gtk-3.0/gtk.css".text = ''
        @import 'colors.css';
        @import url("noctalia.css");
        .thunar { background-color: rgba(44, 44, 44, 0.3); }
        .thunar * { background-color: transparent; }
        .thunar .popup { background-color: rgba(44, 44, 44, 1.0); }
        window { background-color: rgba(44, 44, 44, 0.3); }
        treeview { background-color: transparent; }
        toolbar { background-color: transparent; }
        button { background-color: transparent; }
        messagedialog { background-color: transparent; }
        box { background-color: transparent; }
        notebook { background-color: transparent; }
        .tiled *  { background-color: transparent; }
        columnview { background-color: transparent; }
      '';
      
    ".config/gtk-4.0/gtk.css".text = ''
        @import 'colors.css';
        @import url("noctalia.css");
        window { background-color: rgba(44, 44, 44, 0.3); }
        treeview { background-color: transparent; }
        toolbar { background-color: transparent; }
        button { background-color: transparent; }
        messagedialog { background-color: transparent; }
        box { background-color: transparent; }
        notebook { background-color: transparent; }
        columnview { background-color: transparent; }
      '';

    # wine-reaper
    ".local/share/applications/REAPER(WINE).desktop".text = ''
        [Desktop Entry]
        Name=REAPER (WINE)
        Exec=env WINEPREFIX=/home/kirill/.wine nvidia-offload wine "/home/kirill/.wine/drive_c/Program Files/REAPER (x64)/reaper.exe"
        Type=Application
        StartupNotify=true
        Path=/home/kirill/.wine/drive_c/ProgramData/Microsoft/Windows/Start Menu/Programs/REAPER (x64)
        Icon=cockos-reaper
        StartupWMClass=reaper.exe
      '';
    
    # поддержка визуальной темы
    ".local/share/applications/timeshift-gtk.desktop".text = ''
        [Desktop Entry]
        Name=Timeshift
        Comment=System restore utility
        Exec=sh -c "run0 --setenv=DISPLAY=$DISPLAY --setenv=XAUTHORITY=$XAUTHORITY --setenv=WAYLAND_DISPLAY=$WAYLAND_DISPLAY --setenv=XDG_RUNTIME_DIR=/run/user/$(id -u) timeshift-gtk"
        Icon=timeshift
        GenericName[ru_RU]=Программа для восстановления системы
        GenericName=System Restore Utility
        Keywords=backup;btrfs;rsync;
        Terminal=false
        Type=Application
        Categories=System;
      '';
      
    # временный joplin
    ".local/share/applications/joplin.desktop".text = ''
        [Desktop Entry]
        Categories=Office
        Comment=Joplin for Desktop
        Exec=/home/kirill/joplin-test.sh
        Icon=joplin
        MimeType=x-scheme-handler/joplin
        Name=Joplin
        StartupWMClass=joplin-app-desktop
        Type=Application
        Version=1.5
      '';
    
    # меняю иконку.
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
    # запуск через kitty
    ".local/share/applications/micro.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Micro
        Comment=Micro text editor with terminal and colors
        Exec=kitty -e sh -c "export TERM=xterm-256color; export COLTERM=truecolor; micro %F"
        Icon=micro
        Terminal=false
        MimeType=text/plain;
        Categories=TextEditor;Utility;
      '';
  };

  home.activation = {
    emoveOldBackups = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      $DRY_RUN_CMD rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
      $DRY_RUN_CMD rm -f $HOME/.gtkrc-2.0.backup
    '';

    linkReaperPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      TARGET_DIR="/home/kirill/.dotfiles/reaper_config/REAPER/UserPlugins"
      mkdir -p "$TARGET_DIR"
      ln -sf "${pkgs.reaper-reapack-extension}/UserPlugins/reaper_reapack-x86_64.so" "$TARGET_DIR/"
      ln -sf "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-x86_64.so" "$TARGET_DIR/"
    '';
  };
  
}
