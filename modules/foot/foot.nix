{
  home-manager.users.kirill = { ... }: {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = "~/.config/foot/themes/noctalia";
          font = "Maple Mono NF:size=14";
        };
        colors-dark = {
          alpha = "0.3";
          background = "2C2C2C";
        };
      };
    };
  };
}
