{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles = {
        path = "fg=default";
        path_prefix = "fg=default";
      };
    };
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    ohMyZsh = {
      enable = true;
      plugins = [ "z" ];
    };
    histSize = 5000;
    histFile = "$HOME/.zsh_history";
    setOptions = [ "HIST_IGNORE_ALL_DUPS" ];
  };

  home-manager.users.kirill = { config, ... }: {
    home.file.".p10k.zsh".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/zsh/zsh-powerlevel10k/.p10k.zsh";
  };

  system.activationScripts.copyConfigsForRoot = {
    text = ''
      mkdir -p /root/.config
      if [ -f /home/kirill/.p10k.zsh ]; then
        cp /home/kirill/.p10k.zsh /root/
      fi
      cat > /root/.zshrc <<'EOF'
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      EOF
    '';
    deps = [];
  };
}
