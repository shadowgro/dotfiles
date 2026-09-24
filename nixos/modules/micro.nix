{
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
      autoclose = false;
   	};
  };

  xdg.configFile = {
    "micro/bindings.json".text = ''
      {
      "Ctrl-d": "lua:comment.comment",
      "\u001b[122;6u": "Redo"
      }
    '';

    "micro/syntax/default.yaml".text = ''
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
  };
}
