{ pkgs, ... }:
{
  programs = {

    kitty = {
    	enable = true;
    	package = pkgs.symlinkJoin {
    	    name = "kitty-nvidia";
    	    paths = [ pkgs.kitty ];

    	    nativeBuildInputs = [ pkgs.makeWrapper ];

    	    postBuild = ''
    	      mv "$out/bin/kitty" "$out/bin/kitty-real"

    	      makeWrapper "$out/bin/kitty-real" "$out/bin/kitty" \
    	        --set __NV_PRIME_RENDER_OFFLOAD 1 \
    	        --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
    	        --set __GLX_VENDOR_LIBRARY_NAME nvidia \
    	        --set __VK_LAYER_NV_optimus NVIDIA_only
    	    '';
    	  };
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
    };

    foot = {
      enable = true;
      settings = {
        main = {
          include = "~/.config/foot/themes/noctalia";
          font = "Maple Mono NF:size=14";
        };
        colors-dark = {
          alpha = "0.3";
          background = "2C2C2C";
        };
      };
    };

    yazi.enable = true;
    fzf.enable = true;
    btop.enable = true;
    bat.enable = true;
    git.enable = true;
    fastfetch = {
      enable = true;
    };
  };
}
