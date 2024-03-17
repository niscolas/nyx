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
    ./eww
    ./git
    ./heroic
    ./kanata
    ./ludusavi
    ./mangohud
    ./options.nix
    ./ssh
    inputs.nur.hmModules.nur
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.bottom
    outputs.homeManagerModules.espanso
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.fish
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
  systemd.user.startServices = "sd-switch";

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
    flameshot.enable = true;

    firefox = {
      enable = true;
      enableExtensions = true;

      tridactyl = {
        enable = true;
        enableDebugMode = true;
      };
    };

    fish.enable = true;

    ideavim = {
      enable = true;
      enableDebugMode = true;
    };

    logseq = {
      enable = true;
      enableBackup = true;
    };

    media-dirs = {
      downloads.enableSymlink = true;
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
      enable = true;
      enableDebugMode = true;
    };

    niscolas = {
      awesome = {
        enable = true;
        enableDebugMode = true;
      };

      bspwm.enable = false;

      eww = {
        enable = true;
        enableDebugMode = true;
      };

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
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
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

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Nordzy-cursors";
      size = 16;
      package = pkgs.nordzy-cursor-theme;
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
      pritunl-client
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  qt = {
    enable = true;
    style = {
      name = "gtk2";
      package = pkgs.libsForQt5.qtstyleplugins;
    };
    platformTheme = "gtk";
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
