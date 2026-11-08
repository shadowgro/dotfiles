{
  home-manager.users.kirill = { ... }: {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      extraOptions = [
        "--color=always"
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
