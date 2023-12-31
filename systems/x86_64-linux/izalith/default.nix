{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.minegrub-theme.nixosModules.default
    inputs.nur.nixosModules.nur
    # inputs.nix-index-database.nixosModules.nix-index
    outputs.nixosModules.audio-relay
    outputs.nixosModules.awesome
    outputs.nixosModules.bspwm
    outputs.nixosModules.nix
    outputs.nixosModules.sunshine

    ./audio.nix
    ./bluetooth.nix
    ./gaming.nix
    ./mach-nix-pkgs.nix
    ./performance.nix
    ./video.nix

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };

    overlays = [
      inputs.nvidia-patch.overlay
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  environment = {
    etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

    shells = with pkgs; [
      fish
      nushell
      zsh
    ];

    systemPackages = [
      inputs.home-manager.packages.${pkgs.system}.default
      pkgs.coreutils
      pkgs.gnome.file-roller
      pkgs.lightlocker
      pkgs.rar
    ];
  };

  systemd = {
    services = {
      kanata = {
        serviceConfig = {
          Environment = "DISPLAY=:0";
          Type = "simple";
          User = "root";
        };
        script = "${pkgs.kanata}/bin/kanata --cfg /home/niscolas/.config/kanata/kanata.kbd";
        unitConfig = {
          Description = "Kanata keyboard remapper";
          Documentation = "https://github.com/jtroo/kanata";
        };
        wantedBy = ["default.target"];
      };

      pritunl = {
        serviceConfig = {
          Type = "simple";
          User = "root";
        };
        script = "${pkgs.pritunl-client}/bin/pritunl-client-service";
        wantedBy = ["default.target"];
      };
    };
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
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
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

    blacklistedKernelModules = [
      "i2c_nvidia_gpu"
    ];

    kernelParams = [
      # "intel_pstate=passive"
      "acpi_rev_override"
      "nvidia-drm.modeset=1"
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
          enable = true;
          splash = "100% Flakes!";
        };
        useOSProber = true;
      };

      systemd-boot.enable = false;
    };

    plymouth.enable = true;
  };

  erdtree = {
    audio-relay.enable = true;
    awesome.enable = true;
    bspwm.enable = true;
    nix.enable = true;
    sunshine.enable = true;
  };

  xdg.portal = {
    enable = true;
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

  security.rtkit.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.niscolas = {
      isNormalUser = true;
      description = "Nícolas";
      extraGroups = ["networkmanager" "wheel" "uinput"];
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
    flatpak.enable = true;

    logind.lidSwitchExternalPower = "ignore";

    tailscale.enable = true;

    printing.enable = true;

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
