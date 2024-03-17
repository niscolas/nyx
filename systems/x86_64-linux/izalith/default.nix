{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./gaming.nix
    ./hardware-configuration.nix
    ./performance.nix
    ./video.nix
    inputs.hosts.nixosModule
    {
      networking.stevenBlackHosts = {
        blockFakenews = true;
        blockGambling = true;
        blockPorn = true;
        blockSocial = true;
      };
    }
    inputs.home-manager.nixosModules.home-manager
    inputs.minegrub-theme.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
    outputs.nixosModules.audio-relay
    outputs.nixosModules.awesome
    outputs.nixosModules.binary-cache
    outputs.nixosModules.bspwm
    outputs.nixosModules.nix
    outputs.nixosModules.sunshine
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-19.1.9"
      ];
    };

    overlays = [
      inputs.nvidia-patch.overlay
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      niscolas = import ../../../homes/x86_64-linux/izalith/niscolas;
    };
  };

  environment = {
    etc = {
      current-specialisation.text = ''
        (󰏗)
      '';
    };

    shells = with pkgs; [fish];

    systemPackages = with pkgs; [
      (import ./scripts/my-cpu.nix {inherit config pkgs;})
      (import ./scripts/my-extract.nix {inherit config pkgs;})
      (import ./scripts/my-ram.nix {inherit config pkgs;})
      (import ./scripts/my-thermals.nix {inherit config pkgs;})
      coreutils
      duf
      du-dust
      etcher
      gnome.file-roller
      inputs.home-manager.packages.${pkgs.system}.default
      inputs.nbfc.packages."${pkgs.system}".nbfc
      lightlocker
      rar
      ventoy-full
      xclip
      xdotool
      xorg.xdpyinfo
      xorg.xwininfo
      xz
      zip
    ];
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;

    fish = {
      enable = true;
      vendor.completions.enable = false;
    };

    nm-applet.enable = true;
    xss-lock = {
      enable = true;
      lockerCommand = ''
        ${pkgs.lightlocker}/bin/light-locker-command -l
      '';
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
  };

  boot = {
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    blacklistedKernelModules = [
      "i2c_nvidia_gpu"
      "nouveau"
    ];

    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

    kernelParams = [
      "acpi_rev_override"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        minegrub-theme = {
          enable = false;
          splash = "100% Flakes!";
        };
        useOSProber = true;
      };

      systemd-boot.enable = false;
    };

    plymouth.enable = false;
  };

  nyx = {
    audio-relay.enable = true;
    awesome.enable = true;
    binary-cache.enable = true;
    bspwm.enable = false;
    nix.enable = true;
    sunshine.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;

    users.niscolas = {
      isNormalUser = true;
      description = "Nícolas";
      extraGroups = ["networkmanager" "wheel" "uinput" "input"];
      packages = [];
      shell = pkgs.fish;
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Mononoki" "IntelOneMono" "NerdFontsSymbolsOnly"];})
  ];

  specialisation = {
    steam_off.configuration = {
      services.opensnitch.enable = true;
    };
  };

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    flatpak.enable = true;
    tailscale.enable = true;
    printing.enable = false;

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    openssh.enable = true;
  };

  networking = {
    hostName = "izalith";
    networkmanager.enable = true;

    firewall = {
      # Open ports in the firewall.
      allowedTCPPorts = [24800];
      allowedUDPPorts = [24800];
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.05";
}
