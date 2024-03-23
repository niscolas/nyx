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
    outputs.nixosModules.gnome
    outputs.nixosModules.kde
    outputs.nixosModules.nix
    outputs.nixosModules.sunshine
    outputs.nixosModules.tailscale
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
      inputs.home-manager.packages.${pkgs.system}.default
      inputs.nbfc.packages."${pkgs.system}".nbfc
      intel-media-driver
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

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;

    fish = {
      enable = true;
      vendor.completions.enable = false;
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
    awesome.enable = false;
    binary-cache.enable = true;
    bspwm.enable = false;
    gnome.enable = false;
    kde.enable = true;
    nix.enable = true;
    sunshine.enable = true;
    tailscale.enable = true;
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
    rtkit.enable = true;
    polkit.enable = true;
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

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    flatpak.enable = true;
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
