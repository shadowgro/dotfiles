{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  environment = {
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";
    systemPackages = with pkgs; [ libva-utils intel-gpu-tools ];
  };

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
