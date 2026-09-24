{ pkgs, ... }:

let
  systemctlBin = "/run/current-system/sw/bin/systemctl";
  swayidleBin = "${pkgs.swayidle}/bin/swayidle";
  mmsgBin = "/run/current-system/sw/bin/mmsg";
  noctaliaBin = "/run/current-system/sw/bin/noctalia";

  powerIdle = pkgs.writeShellScript "power-idle" ''
    set -u

    get_power_state() {
      if [ "$(cat /sys/class/power_supply/ACAD/online 2>/dev/null)" = "1" ]; then
        echo ac
      else
        echo battery
      fi
    }

    while true; do
      mode="$(get_power_state)"

      if [ "$mode" = "ac" ]; then
        ${swayidleBin} -w \
          timeout 300 '${mmsgBin} dispatch sleep_monitor,eDP-1' \
          resume '${mmsgBin} dispatch wakeup_monitor,eDP-1' \
          timeout 360 '${noctaliaBin} msg session lock' \
          timeout 600 'systemctl suspend' \
          timeout 3600 'systemctl hibernate' \
          before-sleep '${noctaliaBin} msg session lock'
      else
        ${swayidleBin} -w \
          timeout 120 '${mmsgBin} dispatch sleep_monitor,eDP-1' \
          resume '${mmsgBin} dispatch wakeup_monitor,eDP-1' \
          timeout 180 '${noctaliaBin} msg session lock' \
          timeout 300 'systemctl suspend' \
          timeout 1800 'systemctl hibernate' \
          before-sleep '${noctaliaBin} msg session lock'
      fi

      sleep 1
    done
  '';

in {
  systemd.user.services = {
    swayidle = {
      enable = true;
      description = "Idle management";
      wantedBy = [ "default.target" ];
  
      serviceConfig = {
        ExecStart = powerIdle;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    noctalia-lock = {
      description = "Lock screen on lid close";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${noctaliaBin} msg session lock";
      };
    };
    noctalia-lock-and-suspend = {
      description = "Lock and suspend on battery lid close";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${noctaliaBin} msg session lock_and_suspend";
      };
    };
  };
  
  services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      IdleAction = "ignore";
    };

  services.acpid = {
    enable = true;
  
    lidEventCommands = ''
      case "$1" in
        *close*)
          if [ "$(cat /sys/class/power_supply/ACAD/online 2>/dev/null)" = "1" ]; then
            # AC: только блокировка
            ${systemctlBin} \
              --machine=kirill@.host \
              --user start --wait noctalia-lock.service
          else
            # Battery: блокировка + suspend
            ${systemctlBin} \
              --machine=kirill@.host \
              --user start --wait noctalia-lock-and-suspend.service
          fi
          ;;
  
        *open*)
          ${mmsgBin} dispatch wakeup_monitor,eDP-1
          ;;
      esac
    '';
  };
  
  environment.systemPackages = [
    pkgs.sway-audio-idle-inhibit
  ];
}
