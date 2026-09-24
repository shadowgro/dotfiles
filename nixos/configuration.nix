{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/audio-specialisation.nix
      ./modules/timeshift.nix
      ./modules/file-managers.nix
      # ./modules/idle-lock.nix
    ];

  # Bootloader.
  # boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "nouveau" ];
  # boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos-btw"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # flakes ON
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.thermald.enable = true; # prevents overheating on Intel CPUs
  # services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # CPU_MIN_PERF_ON_AC = 0;
      # CPU_MAX_PERF_ON_AC = 100;
      # CPU_MIN_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT1 = 0; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT1 = 80;  # 80 and above it stops charging
    };
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Moscow";
  time.timeZone = "Asia/Tashkent";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.kdePackages.xdg-desktop-portal-kde
  #     pkgs.xdg-desktop-portal-wlr
  #   ];
  #   config.common.default = [ "kde" ];
  # };

  # services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 36;
      keyboard = {
        layout = "us";
        numlock = true;
      };
      appearance = {
        hide_logo = true;
        # wallpaper = {
        #   path = "/var/lib/noctalia-greeter/blurred-image.png";
        #   fill_mode = "crop"; # center | crop | fit | stretch | repeat
        # };
      };
    };
    cursorTheme = {
      package = pkgs.bibata-cursors-translucent;
      name = "Bibata_Ghost";
    };
  };

  # Configure keymap in X11
  #   services.xserver.xkb = {
  #     layout = "us,ru";
  #     variant = "";
  #     options = "terminate:alt_shift";
  #   };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users."kirill" = {
    isNormalUser = true;
    description = "kirill";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  environment.shellAliases = {
    nixf = "cd ~/.dotfiles/nixos && sudo nixos-rebuild switch --flake .";
    nixfb = "cd ~/.dotfiles/nixos && sudo nixos-rebuild boot --flake .";
    nixfu = "cd ~/.dotfiles/nixos && nix flake update";
  };

  # Enable programs
  programs.firefox.enable = true;
  programs.amnezia-vpn.enable = true;
  programs.niri.enable = true;
  programs.mango.enable = true;

  # for filemanager
  # services.gvfs.enable = true; # Mount, trash, and other functionalities
  # services.tumbler.enable = true; # Thumbnail support for images
  # services.udisks2.enable = true; # for auto-mount and other stuff
  # programs.dconf.enable = true; # for gtk apps
  # programs.thunar.enable = true;
  # programs.xfconf.enable = true; # for thunar
  # programs.thunar.plugins = with pkgs; [
  #   thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
  #   thunar-volman
  # ];

  # zsh
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [

    # Audio
    reaper
    reaper-sws-extension
    reaper-reapack-extension
    qpwgraph            # Visual patchbay for PipeWire
    pwvucontrol         # Modern native PipeWire volume control
    pavucontrol         # Fallback for Pro Audio profile selection
    # easyeffects         # System-wide real-time EQ and effects
    wineWow64Packages.stable
    winetricks
    yabridge
    yabridgectl

    # Programs
    # timeshift
    keepassxc
    amnezia-vpn
    alarm-clock-applet
    # kdePackages.ark
    # kdePackages.kbackup
    # libreoffice-qt
    qbittorrent
    vlc
    inkscape
    zed-editor

    # inputs.zen-browser.packages.${stdenv.hostPlatform.system}.beta
    tor-browser

    yandex-disk
    # joplin-desktop
    telegram-desktop

    # Utils
    # kitty
    # foot
    # micro
    # pcmanfm-qt
    # kdePackages.dolphin
    # thunar
    # inputs.hyprfm.packages.${stdenv.hostPlatform.system}.default
    # nautilus
    # nemo
    # yazi
    # fzf
    # btop
    # bat
    # fastfetch
    # git
    # hashdeep
    hyprpicker
    # ntfs3g
    # rar
    # unrar
    # file-roller
    # xarchiver
    tlp-pd
    power-profiles-daemon

    # Dependencies
    # lxmenu-data # for pcmanfm
    # shared-mime-info # for pcmanfm
    # ffmpegthumbnailer # for pcmanfm
    # gvfs
    # wl-clipboard # for micro
    # xclip # for wine
    # kdePackages.plasma-integration # for qt apps
    # xauth
    # glib
    nil # for zed
    nixd # for zed
    # lxqt.pcmanfm-qt
    # lxqt.libfm-qt
    # lxqt.lxqt-menu-data

    # Environment
    orchis-theme
    noctalia
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lxqt = prev.lxqt // {
  #       pcmanfm-qt = prev.lxqt.pcmanfm-qt.overrideAttrs (old: {
  #         patches = (old.patches or []) ++ [
  #           ./patches/pcmanfm-qt-hide-toolbar-actions.patch
  #         ];
  #       });
  #     };
  #   })
  # ];

  # environment.etc = {
  #   "timeshift/timeshift.json".source = "/home/kirill/.dotfiles/timeshift/timeshift.json";
  #   "xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  # };

  fonts.packages = with pkgs; [
    maple-mono.NF
    comfortaa
    roboto
    # inter-nerdfont
    # quicksand
    # nunito
    # annotation-mono
    # nerd-fonts.jetbrains-mono
  ];

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
      if [ -d /home/kirill/.config/micro ]; then
        cp -r /home/kirill/.config/micro /root/.config/
      fi
      if [ -f /home/kirill/.p10k.zsh ]; then
        cp /home/kirill/.p10k.zsh /root/
      fi
      cat > /root/.zshrc <<'EOF'
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      EOF
    '';
    deps = [];
  };

  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true; # For Wayland
    open = true;
    # nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = { # <-- mode 1
        enable = true;
        enableOffloadCmd = true;
      };
      # sync.enable = true; # <-- mode 2
      intelBusId = "PCI:0@0:2:0";
	  nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
