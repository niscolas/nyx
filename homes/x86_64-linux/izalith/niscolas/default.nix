{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  cfg = config.erdtree;
in {
  imports = [
    outputs.homeManagerModules.home

    ./autorandr
    ./awesome
    ./bspwm
    ./eww
    ./fish
    ./heroic
    ./kanata
    ./logseq
    ./ludusavi
    ./mangohud
    ./nushell
    ./nvim
    ./picom
    ./ssh
    ./stalonetray
    ./starship
    ./tmux
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  erdtree = {
    niscolas = {
      autorandr.enable = true;
      awesome.enable = true;
      bspwm.enable = true;

      eww = {
        enable = true;
        debugModeEnabled = true;
      };

      fish = {
        enable = true;
        enableStarship = true;
      };

      heroic = {
        enable = true;
        enableLudusaviWrapper = true;
      };

      logseq = {
        enable = true;
        enableBackup = true;
      };

      ludusavi.enable = true;
    };

    home.configPath = "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas";
  };

  services = {
    blueman-applet.enable = true;
    opensnitch-ui.enable = true;
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
      ".bin".source = ./.bin;
      ".config/alacritty".source = ./alacritty;
      ".config/bat".source = ./bat;
      ".config/bottom".source = ./bottom;
      ".config/cpupower_gui".source = ./cpupower_gui;
      ".config/flameshot".source = ./flameshot;

      ".config/gh".source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas/gh";

      ".config/git".source = ./git;
      ".config/hidamari".source = ./hidamari;
      ".config/i3".source = ./i3;
      ".config/ideavim".source = ./ideavim;
      ".config/keyd".source = ./keyd;

      ".config/neofetch".source = ./neofetch;
      ".config/omnisharp".source = ./omnisharp;
      ".config/optimus-manager".source = ./optimus-manager;
      ".config/polybar".source = ./polybar;
      ".config/ranger".source = ./ranger;
      ".config/rg".source = ./rg;
      ".config/rofi".source = ./rofi;
      ".config/tridactyl".source = ./tridactyl;
      ".config/wezterm".source = ./wezterm;
      ".config/wired".source = ./wired;
      ".config/zsh".source = ./zsh;
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
      (import ./scripts/my-battery.nix {inherit pkgs;})
      (import ./scripts/kb-layout-swap.nix {inherit pkgs;})
      (builtins.getFlake "github:nbfc-linux/nbfc-linux/0d109723b8c9c407d80272e22d5b2bb12765550b").packages."x86_64-linux".nbfc
      alacritty
      appimage-run
      barrier
      bat
      bottom
      brightnessctl
      cmake
      dbus
      delta
      discord
      easyeffects
      epick
      fd
      flameshot
      fluent-reader
      font-manager
      fzf
      gcc
      gh
      git
      git-lfs
      glxinfo
      gnome.gnome-disk-utility
      gnome.zenity
      google-chrome
      inkscape-with-extensions
      input-leap
      krita
      libnotify
      linux-wallpaperengine
      lm_sensors # for `sensors` command
      lsof # list open files
      ltrace # library call monitoring
      lutris
      lxappearance
      mprocs
      neofetch
      networkmanagerapplet
      nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
      opensnitch-ui
      opentabletdriver
      p7zip
      pavucontrol
      pciutils # lspci
      pritunl-client
      protonup-qt
      r2modman
      rclone
      ripgrep
      rofi
      rustup
      s-tui
      scrcpy
      snixembed
      soundux
      steamtinkerlaunch
      strace # system call monitoring
      stremio
      stress
      stylua
      trayer
      unixtools.xxd
      unzip
      usbutils # lsusb
      vulkan-tools
      wezterm
      wget
      xclip
      xdotool
      xorg.xdpyinfo
      xorg.xwininfo
      xz
      zip
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

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableTridactylNative = true;
        };
      };
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
