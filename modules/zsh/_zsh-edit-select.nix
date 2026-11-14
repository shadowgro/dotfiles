{ pkgs, inputs, ...}:

pkgs.stdenv.mkDerivation {
  pname = "zsh-edit-select";
  version = "unstable";
  src = inputs.zsh-edit-select-src;

  postPatch = ''
    substituteInPlace impl-wayland/backends/wayland-backend.zsh \
      --replace-fail \
        '"$_ZES_PRIMARY_BINARY" --oneshot 2>/dev/null' \
        'if (( $+commands[wl-paste] )); then
              wl-paste --primary --no-newline 2>/dev/null
          else
              "$_ZES_PRIMARY_BINARY" --oneshot 2>/dev/null
          fi'
  '';

  nativeBuildInputs = with pkgs; [
    gnumake
    pkg-config
    wayland-scanner
  ];

  buildInputs = with pkgs; [
    wayland
    wayland-protocols
    libX11
    libXfixes
  ];

  buildPhase = ''
    runHook preBuild

    for dir in \
      impl-wayland/backends/wayland \
      impl-wayland/backends/xwayland \
      impl-x11/backends/x11
    do
      make -C "$dir" CC="$CC" CFLAGS="-O2 -DNDEBUG -Wall -Wextra -Wno-unused-parameter"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/zsh/plugins/zsh-edit-select"
    cp -a . "$out/share/zsh/plugins/zsh-edit-select/"

    runHook postInstall
  '';
}
