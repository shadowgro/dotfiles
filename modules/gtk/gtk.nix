{ ... }:

{
  home-manager.users.kirill = { pkgs, ... }: {

    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Grey-Dark-Compact";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "yet-another-monochrome-icon-set";
        package = pkgs.yamis;
      };
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors-translucent;
      name = "Bibata_Ghost";
      # size = 36;
      # gtk.enable = true;
      # x11.enable = true;
    };

    home.file = {
      ".config/gtk-3.0/gtk.css".text = ''
          @import 'colors.css';
          @import url("noctalia.css");
          .thunar * { background-color: transparent; }
          # .thunar { background-color: rgba(44, 44, 44, 0.3); }
          # .thunar .popup { background-color: rgba(44, 44, 44, 1.0); }
          window { background-color: rgba(44, 44, 44, 0.3); }
          menu { background-color: rgba(44, 44, 44, 1); }
          .menubar { background-color: rgba(44, 44, 44, 1); }
          tooltip { background-color: rgba(44, 44, 44, 1); }
          popover.background { background-color: rgba(44, 44, 44, 1); }
          # menu menuitem:hover { background-color: rgba(44, 44, 44, 1); }
          dialog { background-color: rgba(44, 44, 44, 0.3); }
          .titlebar { background-color: rgba(44, 44, 44, 0.3); }
          menubar { background-color: transparent }
          .sidebar { background-color: transparent; }
          treeview { background-color: transparent; }
          toolbar { background-color: transparent; }
          button { background-color: transparent; }
          messagedialog { background-color: transparent; }
          box { background-color: transparent; }
          notebook { background-color: transparent; }
          # .tiled * { background-color: transparent; }
          columnview { background-color: transparent; }
          headerbar { background-color: transparent; }
          frame { background-color: transparent; }
          notebook * { background-color: transparent; }
          filechooser { background-color: transparent; }
        '';

      ".config/gtk-4.0/gtk.css".text = ''
          @import 'colors.css';
          @import url("noctalia.css");
          window { background-color: rgba(44, 44, 44, 0.3); }
          .content-pane { background-color: transparent }
          .sidebar-pane { background-color: transparent }
          dialog { background-color: rgba(44, 44, 44, 0.3); }
          .titlebar { background-color: transparent; }
          .sidebar { background-color: transparent; }
          treeview { background-color: transparent; }
          toolbar { background-color: transparent; }
          list { background-color: transparent; }
          messagedialog { background-color: transparent; }
          notebook { background-color: transparent; }
          columnview { background-color: transparent; }
          headerbar { background-color: transparent; }
          frame { background-color: transparent; }
          banner * { background-color: transparent; }
          filechooser * { background-color: transparent; }
        '';
    };
  };

  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "26.05";
    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Grey-Dark-Compact";
        package = pkgs.orchis-theme;
      };
    };
  };

  system.activationScripts.copyConfigsForRoot = {
    text = ''
      mkdir -p /root/.config
      if [ -d /home/kirill/.config/gtk-3.0 ]; then
        cp -r /home/kirill/.config/gtk-3.0 /root/.config/
      fi
    '';
    deps = [];
  };
}
