{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/amnezia/amnezia.nix
      ./modules/audio/audio.nix
      ./modules/clippers/clip-bridge.nix
      ./modules/fastfetch/fastfetch.nix
      ./modules/foot/foot.nix
      # ./modules/idle-lock.nix
      ./modules/gtk/gtk.nix
      ./modules/hyprland/hyprland.nix
      ./modules/joplin/joplin.nix
      ./modules/kitty/kitty.nix
      ./modules/mango/mango.nix
      ./modules/micro/micro.nix
      ./modules/noctalia/noctalia.nix
      ./modules/nvidia/nvidia.nix
      ./modules/other-programs/other-programs.nix
      ./modules/pcmanfm-qt/pcmanfm-qt.nix
      ./modules/power/power.nix
      ./modules/qt/qt.nix
      ./modules/reaper/reaper.nix
      ./modules/searxng/searxng.nix
      ./modules/specs/audio-specialisation.nix
      ./modules/thunar/thunar.nix
      ./modules/timeshift/timeshift.nix
      ./modules/wine-d2d1/wine-d2d1.nix
      ./modules/yamis/yamis.nix
      ./modules/zed/zed.nix
      ./modules/zen/zen.nix
      ./modules/zsh/zsh.nix
    ];

  # Bootloader.
  # boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "nouveau" ];
  # boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos-btw"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # flakes ON
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  users.users."kirill" = {
    isNormalUser = true;
    description = "kirill";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  environment.shellAliases = {
    nixf = "cd ~/.dotfiles && sudo nixos-rebuild switch --flake . && noctalia msg notification-show 'Rebuild finished' ";
    nixfb = "cd ~/.dotfiles && sudo nixos-rebuild boot --flake . && noctalia msg notification-show 'Rebuild finished' ";
    nixfu = "cd ~/.dotfiles && nix flake update && noctalia msg notification-show 'Update finished' ";
    nixlg = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    nixdg = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations";
    nixcg = "nix-store --gc && noctalia msg notification-show 'Garbage collected' ";
    nixo = "nix-store --optimise && noctalia msg notification-show 'Storage optimised' ";
  };

  fonts.packages = with pkgs; [
    maple-mono.NF
    comfortaa
    # roboto
    # annotation-mono
    # nerd-fonts.jetbrains-mono
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
