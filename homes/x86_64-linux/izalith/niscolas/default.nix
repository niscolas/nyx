{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # outputs.homeManagerModules.ripgrep
    ./awesome
    ./bspwm
    ./git
    ./heroic
    ./kanata
    ./ludusavi
    ./mangohud
    ./options.nix
    ./ssh
    inputs.nur.hmModules.nur
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.bottom
    outputs.homeManagerModules.espanso
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.flameshot
    outputs.homeManagerModules.ideavim
    outputs.homeManagerModules.logseq
    outputs.homeManagerModules.media-dirs
    outputs.homeManagerModules.modulesData
    outputs.homeManagerModules.neofetch
    outputs.homeManagerModules.nvim
    outputs.homeManagerModules.spicetify
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.wezterm
    outputs.homeManagerModules.zsh
    outputs.nixosModules.binary-cache
  ];

  # nix = {
  #   package = pkgs.nix;
  # };

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
      inputs.nur.overlay
      inputs.nvidia-patch.overlay
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user = {
    startServices = "sd-switch";

    # https://github.com/nix-community/home-manager/issues/2064#issuecomment-887300055
    targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };

  nyx = {
    alacritty = {
      enable = true;
      enableDebugMode = true;
    };

    bottom = {
      enable = true;
      enableDebugMode = true;
    };

    binary-cache.enable = true;
    espanso.enable = true;

    firefox = {
      enable = true;
      enableExtensions = true;

      tridactyl = {
        enable = true;
        enableDebugMode = true;
      };
    };

    flameshot.enable = true;

    ideavim = {
      enable = true;
      enableDebugMode = true;
    };

    logseq = {
      enable = false;
      enableBackup = true;
    };

    media-dirs = {
      downloads.enableSymlink = true;
      videos.enableSymlink = true;
    };

    modulesData.realPath = "${config.home.homeDirectory}/bonfire/nyx/modules/home-manager";

    neofetch = {
      enable = true;
      enableDebugMode = true;
    };

    nvim.enable = true;
    # ripgrep.enable = lib.mkForce true;
    spicetify.enable = true;
    tmux.enable = true;

    wezterm = {
      enable = false;
      enableDebugMode = true;
    };

    zsh.enable = true;

    niscolas = {
      awesome = {
        enable = false;
        enableDebugMode = true;
      };

      bspwm.enable = false;

      heroic = {
        enable = true;
        enableLudusaviWrapper = true;
      };

      git.enable = true;

      kanata = {
        enable = true;
        enableDebugMode = true;
      };

      ludusavi.enable = true;
    };
  };

  services = {
    flatpak.packages = [
      "io.github.achetagames.epic_asset_manager"
      "io.github.jeffshee.Hidamari"
    ];

    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    syncthing.enable = true;
  };

  xresources.properties = {
    "Xft.dpi" = 120;
  };

  home = {
    username = "niscolas";
    homeDirectory = "/home/niscolas";
    file = {
      ".config/cpupower_gui".source = ./cpupower_gui;

      ".config/gh".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas/gh";

      ".config/hidamari".source = ./hidamari;
      ".config/i3".source = ./i3;
      ".config/keyd".source = ./keyd;

      ".config/optimus-manager".source = ./optimus-manager;
      ".config/polybar".source = ./polybar;
      ".config/rofi".source = ./rofi;
    };

    sessionVariables = {
      MACHINE_SETUP = "personal";
      MACHINE_THEME = "gruvbox";
    };

    packages = with pkgs; [
      (import ./scripts/kb-layout-swap.nix {inherit pkgs;})
      (import ./scripts/my-battery.nix {inherit pkgs;})
      appimage-run
      barrier
      bitwarden-cli
      brightnessctl
      cmake
      dbus
      delta
      discord
      dotnet-sdk
      easyeffects
      epick
      fd
      fluent-reader
      font-manager
      fzf
      gh
      glxinfo
      gnome.gnome-disk-utility
      gnome.zenity
      google-chrome
      inkscape-with-extensions
      input-leap
      jetbrains-toolbox
      krita
      libnotify
      linux-wallpaperengine
      lm_sensors # for `sensors` command
      lsof # list open files
      ltrace # library call monitoring
      lutris
      lxappearance
      mprocs
      networkmanagerapplet
      nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
      obsidian
      opentabletdriver
      p7zip
      parsec-bin
      pavucontrol
      pciutils # lspci
      protonup-qt
      qalculate-gtk
      qbittorrent
      r2modman
      rclone
      rofi
      s-tui
      scrcpy
      snixembed
      soundux
      steamtinkerlaunch
      strace # system call monitoring
      stremio
      stress
      stylua
      unixtools.xxd
      unzip
      usbutils # lsusb
      vlc
      vulkan-tools
      wget
      wine-staging
    ];

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Let home Manager install and manage itself.
    home-manager.enable = true;

    obs-studio.enable = true;
  };
}
