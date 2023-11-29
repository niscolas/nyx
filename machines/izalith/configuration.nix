# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./mach-nix-pkgs.nix
        inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            niscolas = import ../../home-manager/niscolas;
        };
    };

    environment.sessionVariables = rec {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_DATA_DIRS = lib.mkDefault "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";

        XDG_BIN_HOME = "$HOME/.bin";
        PATH = [
            "${XDG_BIN_HOME}"
        ];

        MACHINE_SETUP = "personal";
        MACHINE_THEME = "gruvbox";
    };

    environment.localBinInPath = true;
    environment.shells = with pkgs; [ nushell zsh ];

    systemd.timers.backup_logseq = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
            Unit = "backup_logseq.service";
            User = "niscolas";
        };
    };

    systemd.services.backup_logseq = {
        path = with pkgs; [ bash git openssh ];
        serviceConfig = {
            Type = "oneshot";
            User = "niscolas";
        };
        script = "$HOME/scripts/crons/tasks/linux-every_minute.sh";
    };

    systemd.services.kanata = {
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
        wantedBy = [ "default.target" ];
    };

    systemd.services.pritunl = {
        serviceConfig = {
            Type = "simple";
            User = "root";
        };
        script = "${pkgs.pritunl-client}/bin/pritunl-client-service";
        wantedBy = [ "default.target" ];
    };

    services.undervolt = {
        enable = false;
        temp = 85;
        coreOffset = -80;
        gpuOffset = -20;
    };

    services.tlp = {
        enable = false;
        settings = {
            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;

            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

            #CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            #CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 20;

            # The following prevents the battery from charging fully to
            # preserve lifetime. Run `tlp fullcharge` to temporarily force
            # full charge.
            # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
            START_CHARGE_THRESH_BAT0=40;
            STOP_CHARGE_THRESH_BAT0=50;
        };
    };

    services.thermald.enable = false;
    services.auto-cpufreq.enable = false;
    services.throttled = {
        enable = true;
        extraConfig = ''
            [GENERAL]
            # Enable or disable the script execution
            Enabled: True
            # SYSFS path for checking if the system is running on AC power
            Sysfs_Power_Path: /sys/class/power_supply/AC*/online
            # Auto reload config on changes
            Autoreload: True

            ## Settings to apply while connected to Battery power
            [BATTERY]
            # Update the registers every this many seconds
            Update_Rate_s: 30
            # Max package power for time window #1
            PL1_Tdp_W: 29
            # Time window #1 duration
            PL1_Duration_s: 28
            # Max package power for time window #2
            PL2_Tdp_W: 44
            # Time window #2 duration
            PL2_Duration_S: 0.002
            # Max allowed temperature before throttling
            Trip_Temp_C: 75
            # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
            cTDP: 0
            # Disable BDPROCHOT (EXPERIMENTAL)
            Disable_BDPROCHOT: False

            ## Settings to apply while connected to AC power
            [AC]
            # Update the registers every this many seconds
            Update_Rate_s: 5
            # Max package power for time window #1
            PL1_Tdp_W: 44
            # Time window #1 duration
            PL1_Duration_s: 28
            # Max package power for time window #2
            PL2_Tdp_W: 44
            # Time window #2 duration
            PL2_Duration_S: 0.002
            # Max allowed temperature before throttling
            Trip_Temp_C: 85
            # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
            # Uncomment only if you really want to use it
            # HWP_Mode: False
            # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
            cTDP: 0
            # Disable BDPROCHOT (EXPERIMENTAL)
            Disable_BDPROCHOT: False

            # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
            [UNDERVOLT]
            # CPU core voltage offset (mV)
            CORE: -90
            # Integrated GPU voltage offset (mV)
            GPU: -40
            # CPU cache voltage offset (mV)
            CACHE: -90
            # System Agent voltage offset (mV)
            UNCORE: -50
            # Analog I/O voltage offset (mV)
            ANALOGIO: 0

            # [ICCMAX.AC]
            # # CPU core max current (A)
            # CORE:
            # # Integrated GPU max current (A)
            # GPU:
            # # CPU cache max current (A)
            # CACHE:

            # [ICCMAX.BATTERY]
            # # CPU core max current (A)
            # CORE:
            # # Integrated GPU max current (A)
            # GPU:
            # # CPU cache max current (A)
            # CACHE:
        '';
    };

    programs.dconf.enable = true;

    programs.xss-lock = {
        enable = true;
        lockerCommand = ''
            ${pkgs.lightlocker}/bin/light-locker-command -l
            '';
    };

    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };

    programs.gamemode = {
        enable = true;
        settings = {
            custom = {
                start = "${pkgs.procps}/bin/pkill picom";
                end = "''${pkgs.picom}/bin/picom -b";
            };
        };
    };

    programs.steam = {
        enable = true;
        package = pkgs.steam.override {
            extraPkgs = pkgs: with pkgs; [
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

    programs.gamescope = {
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

    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

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

    networking.hostName = "izalith";
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.flatpak.enable = true;

    services.tailscale.enable = true;

# Set your time zone.
    time.timeZone = "America/Sao_Paulo";

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
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

        windowManager.awesome = {
            enable = true;
            luaModules = with pkgs.luaPackages; [
                luarocks # is the package manager for Lua modules
                    luadbi-mysql # Database abstraction layer
            ];
        };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio = {
        enable = false;
        extraConfig = ''
            .nofail
            unload-module module-suspend-on-idle
            .fail
        '';
    };
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };
    environment.etc."wireplumber/main.lua.d/90-suspend-timeout.lua" = {
      text = ''
        apply_properties = {
            ["session.suspend-timeout-seconds"] = 0,
        }
      '';
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    users.defaultUserShell = pkgs.nushell;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.niscolas = {
        isNormalUser = true;
        description = "Nícolas Catarina Parreiras";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [ ];
        shell = pkgs.nushell;
    };

    nixpkgs = {
        config.allowUnfreePredicate = (pkg: true);
        config.allowUnfree = true;
        overlays = [ (import ./overlays.nix) ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = [
        pkgs.mangohud
        (builtins.getFlake "github:nbfc-linux/nbfc-linux/0d109723b8c9c407d80272e22d5b2bb12765550b").packages."x86_64-linux".nbfc
        pkgs.awesome
        pkgs.coreutils
        pkgs.gnome.file-roller
        pkgs.heroic
        pkgs.lightlocker
        pkgs.nix-index
        pkgs.nushell
        pkgs.rar
        pkgs.zsh
    ];

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Mononoki" "IntelOneMono" "NerdFontsSymbolsOnly" ]; })
    ];

    # Make sure opengl is enabled
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        # extraPackages = with pkgs; [mangohud];
        # extraPackages32 = with pkgs; [mangohud];
    };

    hardware.nvidia = {
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
    };

    hardware.nvidia.prime = {
        offload = {
            enable = true;
            enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
    };

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
            services.opensnitch = {
                enable = true;
                rules = {
                    "steam_family_share_bypass" = {
                        "created" = "2023-07-09T18:54:31.048633146-03:00";
                        "updated" = "2023-07-09T18:54:31.048703462-03:00";
                        "name" = "steam_family_share_bypass";
                        "enabled" = false;
                        "precedence" = false;
                        "action" = "allow";
                        "duration" = "always";
                        "operator" = {
                            "type" = "list";
                            "operand" = "list";
                            "sensitive" = false;
                            "data" = [
                            {
                                "type" = "regexp";
                                "operand" = "process.path";
                                "data" = ".*steam.*";
                                "sensitive" = false;
                            }
                            {
                                "type" = "regexp";
                                "operand" = "dest.ip";
                                "data" = "(192.[0-168].[0-2].[1-249])|(254.254.254.254)";
                                "sensitive" = false;
                            }
                            ];
                            "list" = [
                            {
                                "type" = "regexp";
                                "operand" = "process.path";
                                "sensitive" = false;
                                "data" = ".*steam.*";
                                "list" = null;
                            }
                            {
                                "type" = "regexp";
                                "operand" = "dest.ip";
                                "sensitive" = false;
                                "data" = "(192\\.[0-168]\\.[0-2]\\.[1-249])|(254.254.254.254)";
                                "list" = null;
                            }
                            ];
                        };
                    };
                };
            };
        };
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 7d";

    services.udev.extraRules = ''
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
        '';

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
    services.openssh.enable = true;

# Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [
        24800

# sunshine
            47984 47989 48010

            50000 59100 59200 59716
    ];

    networking.firewall.allowedUDPPorts = [
        24800

# sunshine
            47998 47999 48000 48002 48010

            50000 59100 59200 59716
    ];


    virtualisation.docker.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
}
