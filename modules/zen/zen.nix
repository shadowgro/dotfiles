{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "zen-beta-nvidia";
      paths = [ inputs.zen-browser.packages.${stdenv.hostPlatform.system}.beta ];
      postBuild = ''
        rm "$out/bin/zen-beta"
        cat > "$out/bin/zen-beta" <<'EOF'
        #!/bin/sh
        exec /run/current-system/sw/bin/nvidia-offload \
          ${inputs.zen-browser.packages.${stdenv.hostPlatform.system}.beta}/bin/zen-beta "$@"
        EOF
        chmod +x "$out/bin/zen-beta"
      '';
    })
  ];
}
