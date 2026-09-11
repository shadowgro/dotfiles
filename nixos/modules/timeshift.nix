{ config, pkgs, lib, ... }:

let
  username = "kirill";

  notifySuccess = "timeshift-notify-success.service";
  notifyFailure = "timeshift-notify-failure.service";

  startUserService = service:
    "${pkgs.systemd}/bin/systemctl --machine=${username}@.host --user start ${service}";

  timeshiftRetention = pkgs.writeShellScript "timeshift-retention" ''
    set -euo pipefail
  
    snapshot_dir="/timeshift/snapshots"
    max_snapshots=7
  
    mapfile -t daily_snapshots < <(
      for info in "$snapshot_dir"/*/info.json; do
        [ -f "$info" ] || continue
  
        if [ "$(${pkgs.jq}/bin/jq -r '.tags' "$info")" = "daily" ]; then
          ${pkgs.coreutils}/bin/basename "$(${pkgs.coreutils}/bin/dirname "$info")"
        fi
      done |
      ${pkgs.coreutils}/bin/sort
    )
  
    count=''${#daily_snapshots[@]}
  
    echo "Found $count daily snapshots."
  
    if (( count <= max_snapshots )); then
      echo "Nothing to delete."
      exit 0
    fi
  
    delete_count=$((count - max_snapshots))
  
    echo "Keeping newest $max_snapshots daily snapshots."
    echo "Deleting $delete_count old daily snapshots."
  
    for ((i = 0; i < delete_count; i++)); do
      snapshot="''${daily_snapshots[i]}"
  
      echo "Deleting: $snapshot"
  
      ${pkgs.timeshift}/bin/timeshift \
        --delete \
        --snapshot "$snapshot" \
        --yes \
        --scripted
    done
  '';

in
{
  # ─────────────────────────────────────────────
  # User notifications
  # ─────────────────────────────────────────────

  systemd.user.services.timeshift-notify-success = {
    description = "Notify on successful Timeshift snapshot";

    unitConfig = {
      After = [ "graphical-session.target" ];
    };

    serviceConfig = {
      Type = "oneshot";

      ExecStart =
        "${pkgs.libnotify}/bin/notify-send "
        + "'Timeshift' "
        + "'Daily snapshot created successfully.'";
    };
  };

  systemd.user.services.timeshift-notify-failure = {
    description = "Notify on failed Timeshift snapshot";

    unitConfig = {
      After = [ "graphical-session.target" ];
    };

    serviceConfig = {
      Type = "oneshot";

      ExecStart =
        "${pkgs.libnotify}/bin/notify-send "
        + "-u critical "
        + "'Timeshift Error' "
        + "'Failed to create daily snapshot!'";
    };
  };


  # ─────────────────────────────────────────────
  # System → user notification bridges
  # ─────────────────────────────────────────────

  systemd.services.timeshift-notify-success-bridge = {
    description = "Trigger Timeshift success notification";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = startUserService notifySuccess;
    };
  };

  systemd.services.timeshift-notify-failure-bridge = {
    description = "Trigger Timeshift failure notification";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = startUserService notifyFailure;
    };
  };


  # ─────────────────────────────────────────────
  # Timeshift
  # ─────────────────────────────────────────────

  systemd.services.timeshift-backup = {
    description = "Create daily Timeshift snapshot";

    path = with pkgs; [
      timeshift
      util-linux
      lvm2
      coreutils
      bash
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      ExecStartPre =
        "${pkgs.coreutils}/bin/mkdir -p /root/.temp";

      Environment = [
        "TMPDIR=/root/.temp"
      ];

      PrivateTmp = false;
      ProtectHome = false;

      ExecStart =
        "${pkgs.timeshift}/bin/timeshift --create --scripted --tags D";
    };

    unitConfig = {
      OnSuccess = [
        "timeshift-retention.service"
        "timeshift-notify-success-bridge.service"
      ];
    
      OnFailure = [
        "timeshift-notify-failure-bridge.service"
      ];
    };
  };


  # ─────────────────────────────────────────────
  # Daily timer
  # ─────────────────────────────────────────────

  systemd.timers.timeshift-backup = {
    description = "Daily Timeshift snapshot";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 06:00:00";
      Persistent = true;
    };
  };

  systemd.services.timeshift-retention = {
    description = "Remove old Timeshift daily snapshots";
  
    path = with pkgs; [
      timeshift
      util-linux
      lvm2
      coreutils
      bash
    ];
  
    serviceConfig = {
      Type = "oneshot";
      User = "root";
  
      ExecStartPre =
        "${pkgs.coreutils}/bin/mkdir -p /root/.temp";
  
      Environment = [
        "TMPDIR=/root/.temp"
      ];
  
      PrivateTmp = false;
      ProtectHome = false;
  
      ExecStart = timeshiftRetention;
    };
  };
  
  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "20 23 * * * root ${pkgs.timeshift}/bin/timeshift --create --scripted --tags D"
  #   ];
  # };

}
