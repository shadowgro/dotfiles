{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,

  alsa-lib,
  curl,
  gtk3,
  lame,
  libxml2_13,
  libjack2,
  ffmpeg-headless,
  vlc,
  xdg-utils,
  xdotool,
  which,
  openssl,

  jackSupport ? stdenv.hostPlatform.isLinux,
  jackLibrary ? libjack2, # Another option is "pipewire.jack"
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
}:

let
  url_for_platform =
    version: arch:
    "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${
      builtins.replaceStrings [ "." ] [ "" ] version
    }_linux_${arch}.tar.xz";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "reaper_wrapped";
  version = "7.86";

  src = fetchurl {
    url = url_for_platform finalAttrs.version stdenv.hostPlatform.qemuArch;
    hash = "sha256-wvnYYWvR3GF1mTuCRR4cbjUsZ2Hnrm1yQAo/PfsDvts=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    which
    autoPatchelfHook
    xdg-utils # Required for install script
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # reaper and libSwell need libstdc++.so.6
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    alsa-lib
  ];

  runtimeDependencies =
    lib.optionals stdenv.hostPlatform.isLinux [
      gtk3 # libSwell needs libgdk-3.so.0
    ]
    ++ lib.optional jackSupport jackLibrary
    ++ lib.optional pulseaudioSupport libpulseaudio;

  dontBuild = true;
  dontStrip = true;

  patchelfFlags = [
    "--page-size"
    "2097152"
  ];

  installPhase = ''
    runHook preInstall

    HOME="$out/share" XDG_DATA_HOME="$out/share" ./install-reaper.sh \
      --install $out/opt \
      --integrate-user-desktop
    rm $out/opt/REAPER/uninstall-reaper.sh

    wrapProgram $out/opt/REAPER/reaper \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          curl
          lame
          libxml2_13
          ffmpeg-headless
          vlc
          xdotool
          stdenv.cc.cc
          openssl
        ]
      }"

    mkdir $out/bin
    ln -s $out/opt/REAPER/reaper $out/bin/

    # Avoid store path in Exec, since we already link to $out/bin
    substituteInPlace $out/share/applications/cockos-reaper.desktop \
      --replace-fail "Exec=\"$out/opt/REAPER/reaper\"" "Exec=reaper"

    runHook postInstall
  '';

  passthru.updateScript = ./updater.sh;
})
