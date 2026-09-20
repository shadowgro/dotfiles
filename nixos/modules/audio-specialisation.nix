{ config, pkgs, lib, ... }:

{
    specialisation = {
    audio.configuration = {

      boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_xanmod_latest;
      boot.kernelParams = [
        "threadirqs"
        "preempt=full"
#         "amd_pstate=active"         # Zen 4/5: active mode provides best EPP and responsiveness
        "usbcore.autosuspend=-1"    # Prevent USB audio interface sleep
      ];

      # Disable power-profiles-daemon to prevent conflicts with manual cpuFreqGovernor
      # services.power-profiles-daemon.enable = pkgs.lib.mkForce false;
      # powerManagement.cpuFreqGovernor = "performance";

      # musnix setup
      musnix.enable = true;
#       musnix.rtcqs.enable = true;
#       musnix.kernel.realtime = true;
#       security.allowSimultaneousMultithreading = false;

      services.pipewire = {
        wireplumber.enable = true;

        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;  # Fixed rate avoids resampling latency
            "default.clock.quantum" = 128;      # ~5ms latency at 48kHz
            "default.clock.min-quantum" = 32;   # Allows top-tier interfaces to achieve ~1.5ms
            "default.clock.max-quantum" = 512;
          };
        };

#         wireplumber.extraConfig."99-disable-suspend" = {
#           "monitor.alsa.rules" = [{
#             matches = [
#               { "node.name" = "~alsa_input.*"; }
#               { "node.name" = "~alsa_output.*"; }
#             ];
#             actions = {
#               update-props = {
#                 "session.suspend-timeout-seconds" = 0;
#               };
#             };
#           }];
#         };

          # Allow unlimited memlock and high rtprio for real-time audio buffers
          # security.pam.loginLimits = [
          #   { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
          #   { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
          #   { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
          # ];

          # Plugin Search Paths
          # environment.variables = let
          #   makePluginPath = format:
          #     (pkgs.lib.makeSearchPath format [
          #       "$HOME/.nix-profile/lib"
          #       "/run/current-system/sw/lib"
          #       "/etc/profiles/per-user/$USER/lib"
          #     ]) + ":$HOME/.${format}";
          # in
          #   LV2_PATH = makePluginPath "lv2";
          #   VST3_PATH = makePluginPath "vst3";
          #   CLAP_PATH = makePluginPath "clap";
          #   };
      };
    };
  };

}
