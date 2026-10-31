{ pkgs, ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol         # Modern native PipeWire volume control
    pavucontrol         # Fallback for Pro Audio profile selection
    qpwgraph            # Visual patchbay for PipeWire
    easyeffects         # System-wide real-time EQ and effects
  ];
}
