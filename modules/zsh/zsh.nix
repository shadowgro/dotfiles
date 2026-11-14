{ pkgs, lib, inputs, ... }:

let
  fzfShortcutOpts = lib.concatStringsSep " " [
    "--layout=reverse"
    "--border=rounded"
    "--margin=3%"
    "--preview ''"
  ];
in

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = [ pkgs.oh-my-posh ];
  environment.variables = {
    FZF_DEFAULT_OPTS = lib.concatStringsSep " " [
      "--layout=reverse"
      "--style=minimal"
      "--preview 'bat --color=always {} -p'"
      "--bind 'focus:transform-header:file --brief {}'"
      "--multi"
      "--color=16,fg:-1,bg:-1,fg+:-1,bg+:8,gutter:8,prompt:2,pointer:8,marker:-1,info:-1,header:-1,spinner:3,border:-1"
    ];
    FZF_CTRL_T_OPTS = fzfShortcutOpts;
    FZF_CTRL_R_OPTS = fzfShortcutOpts;
    FZF_ALT_C_OPTS  = fzfShortcutOpts;
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

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
      nixf  = "cd ~/.dotfiles && { rom build .#nixosConfigurations.nixos-btw.config.system.build.toplevel && dix diff /run/current-system ./result && noctalia msg notification-show 'Rebuild finished' && sudo nixos-rebuild switch --flake . ; } || noctalia msg notification-show 'Rebuild failed' ";
      nixfb = "cd ~/.dotfiles && { rom build .#nixosConfigurations.nixos-btw.config.system.build.toplevel && dix diff /run/current-system ./result && noctalia msg notification-show 'Rebuild finished' && sudo nixos-rebuild boot --flake . ; } || noctalia msg notification-show 'Rebuild failed' ";
      nixfs = "cd ~/.dotfiles && sudo nixos-rebuild switch --flake . && dix last && noctalia msg notification-show 'Rebuild finished' ";
      nixfu = "cd ~/.dotfiles && cp flake.lock flacke.lock.backup && nix flake update && noctalia msg notification-show 'Update finished' ";
      nixlg = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixdg = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations";
      nixcg = "nix-store --gc && noctalia msg notification-show 'Garbage collected' ";
      nixo  = "nix-store --optimise && noctalia msg notification-show 'Storage optimised' ";

      git-on  = "cd ~/.dotfiles && [[ -d .git.disabled ]] && mv .git.disabled .git && echo 'Git: ON' || echo 'NOPE' ";
      git-off = "[[ -d ~/.dotfiles/.git ]] && mv ~/.dotfiles/.git ~/.dotfiles/.git.disabled && echo 'Git: OFF' || echo 'NOPE' ";
      ls = "eza -al --color=always --group-directories-first --icons=always --no-user --no-permissions";
      c = "clear";
    };
    promptInit = "";
    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh
      source ${pkgs.zsh-nix-shell}/share/zsh/plugins/zsh-nix-shell/nix-shell.plugin.zsh
      source ${import ./_zsh-edit-select.nix { inherit pkgs inputs; }}/share/zsh/plugins/zsh-edit-select/zsh-edit-select.plugin.zsh

      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --color=16,fg:-1,bg:-1,fg+:-1,bg+:8,gutter:8,prompt:2,pointer:8,marker:-1,info:-1,header:-1,spinner:3,border:-1

      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' emacs-forward-word
      bindkey '^H' backward-kill-word
      bindkey '^[OA' history-search-backward
      bindkey '^[OB' history-search-forward
      bindkey '^[[1;5A' up-line-or-history
      bindkey '^[[1;5B' down-line-or-history

      WORDCHARS=''${WORDCHARS//[\/]/}


      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${./oh-my-posh/mytheme.toml})"
    '';

    histSize = 3000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "APPENDHISTORY"
      "SHAREHISTORY"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
    ];
  };

  home-manager.users.kirill.xdg.configFile."zsh-edit-select/config".text = ''
    EDIT_SELECT_MOUSE_REPLACEMENT=0
    EDIT_SELECT_KEY_SELECT_ALL='^A'
    EDIT_SELECT_KEY_CUT='^X'
    EDIT_SELECT_KEY_UNDO='^Z'
    EDIT_SELECT_KEY_REDO='^[[90;6u'
    EDIT_SELECT_KEY_WORD_LEFT='^[[1;5D'
    EDIT_SELECT_KEY_WORD_RIGHT='^[[1;5C'
    EDIT_SELECT_KEY_BUFFER_START='^[[1;6H'
    EDIT_SELECT_KEY_BUFFER_END='^[[1;6F'
    EDIT_SELECT_KEY_COPY='^[[67;6u'
    EDIT_SELECT_KEY_PASTE='^[[86;6u'
  '';
}
