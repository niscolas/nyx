{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs = {
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "${pkgs.procps}/bin/pkill compfy";
          end = "''${pkgs.picom}/bin/compfy";
        };
      };
    };

    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            # stdenv.cc.cc.lib
            xorg.libXScrnSaver
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
          ];
      };
      remotePlay.openFirewall = true;
    };

    gamescope = {
      enable = false;
      # capSysNice = true;
      args = [
        # "--rt"
        # "--prefer-vk-device 10de:249d"
      ];
      env = {
        # SDL_VIDEODRIVER = "x11";
        # GBM_BACKEND = "nvidia-drm";
        # ENABLE_VKBASALT = "1";
        # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # __GL_THREADED_OPTIMIZATIONS = "0";
        # __NV_PRIME_RENDER_OFFLOAD = "1";
        # __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };
}
