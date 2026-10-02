{
  home-manager.users.kirill = { ... }: {

    programs.micro = {
     	enable = true;
     	settings = {
        clipboard = "external";
        colorscheme = "simple";
        history = 100;
        hlsearch = true;
        savecursor = true;
        savehistory = true;
        scrollspeed = 3;
        softwrap = true;
        wordwrap = true;
        autoclose = false;
     	};
    };

    home.file = {
      ".config/micro/bindings.json".text = ''
        {
        "Ctrl-d": "lua:comment.comment",
        "\u001b[122;6u": "Redo"
        }
      '';

      ".config/micro/syntax/default.yaml".text = ''
        filetype: default
        detect:
        filename: ".*"
        rules:
        - constant.string:
        start: "\""
        end: "\""
        skip: "\\\\."
        rules:
        - constant.specialChar: "\\\\([0-7]{3}|x[0-9A-Fa-f]{2}|.)"
        - comment: "#.*$"
        - keyword.operator: "\\=|\\,|\\.|\\;|\\:|\\+|\\-|\\*|\\/|\\%|\\&|\\||\\!|\\<|\\>"
        - constant.numeric: "\\b[0-9]+\\b"
        - keyword: "\\b(if|then|else|fi|for|while|do|done|case|esac|function|return|export|local)\\b"
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
  };

  system.activationScripts.copyConfigsForRoot = {
    text = ''
      mkdir -p /root/.config
      if [ -d /home/kirill/.config/micro ]; then
        cp -r /home/kirill/.config/micro /root/.config/
      fi
    '';
    deps = [];
  };
}
