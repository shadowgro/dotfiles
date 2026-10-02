{
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
}
