{
  config,
  pkgs,
  ...
}: {
  hardware = {
    # Make sure opengl is enabled
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement.enable = true;

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

    excludePackages = with pkgs; [
      xterm
    ];

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

    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };

    displayManager = {
      lightdm = {
        enable = true;
      };

      sessionCommands = ''
        ${pkgs.lightlocker}/bin/light-locker --lock-on-suspend &
      '';

      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --auto
      '';

      defaultSession = "none+awesome";
    };

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };

      leftwm.enable = true;
    };
  };
}
