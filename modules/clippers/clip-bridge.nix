{ pkgs, inputs, ... }:

let
  clip-bridge = pkgs.rustPlatform.buildRustPackage {
    pname = "clip-bridge";
    version = inputs.clip-bridge-src.lastModifiedDate;
    src = inputs.clip-bridge-src;
    cargoLock = {
      lockFile = "${inputs.clip-bridge-src}/Cargo.lock";
    };
  };
in
{
  environment.systemPackages = [
    pkgs.wl-clipboard # for micro
    pkgs.xclip # for wine
    clip-bridge
  ];

  systemd.user.services.clip-bridge = {
    description = "X11/Wayland clipboard bridge";

    wantedBy = [ "graphical-session.target" ];

    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${clip-bridge}/bin/clip-bridge";

      Environment = [
        "DISPLAY=:0"
      ];

      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
