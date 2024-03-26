{
  config,
  pkgs,
  inputs,
  ...
}: let
  rev = "564c0661a942f7163cb2cfa6cb1b14b4bcff3a30"; # revision from https://github.com/keylase/nvidia-patch to use
  hash = "sha256-85h94r3XZq1wME6+AxsTIIsM1TmMMr97RJjDygdnxtA="; # sha256sum for https://github.com/keylase/nvidia-patch at the specified revision

  # create patch functions for the specified revision
  nvidia-patch = pkgs.nvidia-patch rev hash;

  # nvidia package to patch
  nvidia-package = config.boot.kernelPackages.nvidiaPackages.stable;
in {
  hardware = {
    # Make sure opengl is enabled
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      # https://nixos.wiki/wiki/Accelerated_Video_Playback
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];

      # extraPackages = with pkgs; [mangohud];
      # extraPackages32 = with pkgs; [mangohud];
    };

    nvidia = {
      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;

      forceFullCompositionPipeline = true;

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = false;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = nvidia-patch.patch-nvenc (nvidia-patch.patch-fbc nvidia-package);

      powerManagement = {
        enable = true;
        finegrained = false;
      };

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];

    config = ''
      Section "ServerLayout"
      Identifier "Default Layout"
      Screen "nvidia" 0 0
      EndSection

      Section "Module"
      Load "modesetting"
      Load "glx"
      EndSection

      Section "Device"
      Identifier "nvidia"
      Driver "nvidia"
      BusID "PCI:1:0:0"
      Option "AllowEmptyInitialConfiguration"
      Option "PrimaryGPU" "yes
      EndSection

      Section "Device"
      Identifier "intel"
      Driver "modesetting"
      Option "AccelMethod" "sna"
      EndSection

      Section "Screen"
      Identifier "nvidia"
      Device "nvidia"
      Option "AllowEmptyInitialConfiguration"
      EndSection

      Section "Screen"
      Identifier "intel"
      Device "intel"
      EndSection
    '';

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Tell Xorg to use the nvidia driver
    videoDrivers = ["nvidia"];
  };
}
