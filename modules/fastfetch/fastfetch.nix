{
  home-manager.users.kirill = { ... }: {
    programs.fastfetch.enable = true;

    xdg.configFile = {
      "fastfetch/config.jsonc".source = ./config.jsonc;
      "fastfetch/reaper_ansi.txt".source = ./reaper_ansi.txt;
    };
  };
}
