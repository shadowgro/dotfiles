{
  home-manager.users.kirill.programs.kitty = {
    enable = true;
      # package = pkgs.symlinkJoin {
      #   name = "kitty-nvidia";
      #   paths = [ pkgs.kitty ];

      #   nativeBuildInputs = [ pkgs.makeWrapper ];

      #   postBuild = ''
      #     mv "$out/bin/kitty" "$out/bin/kitty-real"

      #     makeWrapper "$out/bin/kitty-real" "$out/bin/kitty" \
      #       --set __NV_PRIME_RENDER_OFFLOAD 1 \
      #       --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
      #       --set __GLX_VENDOR_LIBRARY_NAME nvidia \
      #       --set __VK_LAYER_NV_optimus NVIDIA_only
      #  '';
      # };

    settings = {
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      background_opacity = "0.3";
      font_family = "Maple Mono NF";
      font_size = "14.0";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      include = "themes/noctalia.conf";
      confirm_os_window_close = 0;
    };

    extraConfig = ''
      # Option A (Default): Ctrl+Shift+C = copy
      map ctrl+shift+c send_text all \x1b[67;6u

      # ── zsh-edit-select undo / redo ─────────────────────────
      map ctrl+shift+z send_text all \x1b[90;6u

      # ── zsh-edit-select selection shortcuts ─────────────────────
      # Pass Shift and Ctrl+Shift keys through to Zsh for selection.
      # These override any default or custom Kitty mappings on these keys.
      map shift+left        no_op
      map shift+right       no_op
      map shift+up          no_op
      map shift+down        no_op
      # Ctrl+Shift+Left/Right default to previous_tab/next_tab in Kitty — disable them:
      map ctrl+shift+left   no_op
      map ctrl+shift+right  no_op
    '';
  };
}
