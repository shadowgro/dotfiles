{ pkgs, ... }:

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

  security.run0.enable = true;

  environment.etc."timeshift/timeshift.json".text = ''
    {
      "backup_device_uuid" : "e39c7ba7-29e2-41f9-855e-e9b00fee0f90",
      "parent_device_uuid" : "",
      "do_first_run" : "false",
      "btrfs_mode" : "false",
      "include_btrfs_home_for_backup" : "false",
      "include_btrfs_home_for_restore" : "false",
      "stop_cron_emails" : "false",
      "schedule_monthly" : "false",
      "schedule_weekly" : "false",
      "schedule_daily" : "false",
      "schedule_hourly" : "false",
      "schedule_boot" : "false",
      "count_monthly" : "2",
      "count_weekly" : "8",
      "count_daily" : "7",
      "count_hourly" : "6",
      "count_boot" : "5",
      "snapshot_size" : "0",
      "snapshot_count" : "84863",
      "date_format" : "%Y-%m-%d %H:%M:%S",
      "exclude" : [
        "/home/kirill/.cache/***",
        "/var/empty/**",
        "/nix/***",
        "/tmp/***",
        "/timeshift/***",
        "/dev/***",
        "/proc/***",
        "/sys/***",
        "/run/***",
        "/var/run/***",
        "/lost+found/***",
        "/home/kirill/.local/share/Trash/***",
        "/home/kirill/Yandex.Disk/***",
        "/home/kirill/Downloads/***",
        "/home/kirill/Загрузки/***",
        "+ /home/kirill/**",
        "+ /root/**"
      ],
      "exclude-apps" : []
    }
  '';

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
