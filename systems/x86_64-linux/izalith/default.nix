# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.nur.nixosModules.nur
    outputs.nixosModules.audio-relay
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

    sessionVariables = {
      MACHINE_SETUP = "personal";
      MACHINE_THEME = "gruvbox";
    };

    shells = with pkgs; [
      fish
      nushell
      zsh
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = [
      inputs.home-manager.packages.${pkgs.system}.default
      pkgs.awesome
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
        useOSProber = true;
      };

      systemd-boot.enable = false;
    };

    plymouth.enable = true;
  };

  erdtree = {
    audio-relay.enable = true;
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
    eco_mode.configuration = {
      services.tlp = {
        enable = false;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "power";

          CPU_MAX_PERF_ON_AC = lib.mkForce 50;
        };
      };
    };

    steam_off.configuration = {
      services.opensnitch.enable = true;
    };
  };

  services = {
    flatpak.enable = true;

    tailscale.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    openssh.enable = true;
  };

  networking = {
    hostName = "izalith";
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
    firewall = {
      # Open ports in the firewall.
      allowedTCPPorts = [24800];
      allowedUDPPorts = [24800];
    };
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
