{ pkgs, ...}:

{
  # services.thermald.enable = true; # prevents overheating on Intel CPUs
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
      TLP_PROFILE_AC = "PRF";
      TLP_PROFILE_BAT = "SAV";

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT1 = 0; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT1 = 80;  # 80 and above it stops charging
    };
  };

  environment.systemPackages = with pkgs; [
    tlp-pd
    power-profiles-daemon
  ];
}
