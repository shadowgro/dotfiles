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
    shellAliases = {
      nixf = "cd ~/.dotfiles && sudo nixos-rebuild switch --flake . && noctalia msg notification-show 'Rebuild finished' ";
      nixfb = "cd ~/.dotfiles && sudo nixos-rebuild boot --flake . && noctalia msg notification-show 'Rebuild finished' ";
      nixfu = "cd ~/.dotfiles && nix flake update && noctalia msg notification-show 'Update finished' ";
      nixlg = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixdg = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations";
      nixcg = "nix-store --gc && noctalia msg notification-show 'Garbage collected' ";
      nixo = "nix-store --optimise && noctalia msg notification-show 'Storage optimised' ";

      git-on  = "cd ~/.dotfiles && [[ -d .git.disabled ]] && mv .git.disabled .git && echo 'Git: ON' || echo 'NOPE' ";
      git-off = "[[ -d ~/.dotfiles/.git ]] && mv ~/.dotfiles/.git ~/.dotfiles/.git.disabled && echo 'Git: OFF' || echo 'NOPE' ";
      ls = "eza -al --color=always --group-directories-first --header";
    };
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    ohMyZsh = {
      enable = true;
      plugins = [ "z" ];
    };
    histSize = 3000;
    histFile = "$HOME/.zsh_history";
    setOptions = [ "HIST_IGNORE_ALL_DUPS" ];
  };

  home-manager.users.kirill = { config, ... }: {
    home.file.".p10k.zsh".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/zsh/zsh-powerlevel10k/.p10k.zsh";

    home.file.".zshrc".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/modules/zsh/.zshrc";
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
