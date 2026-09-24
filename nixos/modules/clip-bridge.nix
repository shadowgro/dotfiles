{ pkgs, ... }:

let
  clip-bridge-src = pkgs.fetchFromGitHub {
    owner = "noctisynth";
    repo = "clip-bridge";
    rev = "4f4ea8a7bf6112e23fe1d393064345288071712c";
    hash = "sha256-HyofP8YyV6c2q/H2Qm44MoG8cihZU/E40ei6LG2Kar8=";
  };

  clip-bridge = pkgs.rustPlatform.buildRustPackage {
    pname = "clip-bridge";
    version = "unstable-2026-09-21";

    src = clip-bridge-src;

    cargoLock = {
      lockFile = "${clip-bridge-src}/Cargo.lock";
    };
  };
in
{
  home.packages = [
    pkgs.wl-clipboard # for micro
    pkgs.xclip # for wine
    clip-bridge
  ];

  systemd.user.services.clip-bridge = {
    Unit = {
      Description = "X11/Wayland clipboard bridge";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${clip-bridge}/bin/clip-bridge";

      Environment = [
        "DISPLAY=:0"
        "WAYLAND_DISPLAY=wayland-0"
      ];

      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
