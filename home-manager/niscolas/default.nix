{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./mangohud/default.nix
    ./eww/default.nix
    ./kanata/default.nix
    ./logseq/default.nix
    ./nushell/default.nix
    ./nvim/default.nix
    ./ssh/default.nix
    ./tmux/default.nix
  ];

  nixpkgs = {
    config.allowUnfreePredicate = pkg: true;
    config.allowUnfree = true;
    overlays = [
      (import ./overlays.nix)
      inputs.neovim-nightly-overlay.overlay
    ];
  };

  home.username = "niscolas";
  home.homeDirectory = "/home/niscolas";
  home.file = {
    ".bin".source = ./.bin;
    ".config/alacritty".source = ./alacritty;
    ".config/awesome".source = ./awesome;
    ".config/bat".source = ./bat;
    ".config/bottom".source = ./bottom;
    ".config/bspwm".source = ./bspwm;
    ".config/cpupower_gui".source = ./cpupower_gui;
    ".config/flameshot".source = ./flameshot;

    ".config/gh".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/gh";

    ".config/git".source = ./git;
    ".config/hidamari".source = ./hidamari;
    ".config/i3".source = ./i3;
    ".config/ideavim".source = ./ideavim;
    ".config/keyd".source = ./keyd;

    ".config/ludusavi".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/ludusavi";

    ".config/neofetch".source = ./neofetch;
    ".config/omnisharp".source = ./omnisharp;
    ".config/optimus-manager".source = ./optimus-manager;
    ".config/picom".source = ./picom;
    ".config/polybar".source = ./polybar;
    ".config/ranger".source = ./ranger;
    ".config/rg".source = ./rg;
    ".config/rofi".source = ./rofi;
    ".config/sxhkd".source = ./sxhkd;
    ".config/tridactyl".source = ./tridactyl;
    ".config/wezterm".source = ./wezterm;
    ".config/wired".source = ./wired;
    ".config/zsh".source = ./zsh;
  };

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  services.blueman-applet.enable = true;
  services.opensnitch-ui.enable = true;
  services.network-manager-applet.enable = true;
  services.syncthing = {
    enable = true;
  };

  services.stalonetray = {
    enable = true;
    # https://github.com/kolbusa/stalonetray/blob/master/stalonetrayrc.sample.in
    config = {
      background = "#32302F";
      grow_gravity = "E";
      icon_size = "24";
      kludges = "fix_window_pos,force_icons_size";
      slot_size = "32x32";
      window_layer = "bottom";
    };
  };

  xresources.properties = {
    "Xft.dpi" = 120;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Nordzy-cursors";
    size = 16;
    package = pkgs.nordzy-cursor-theme;
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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    };
  };

  home.packages = with pkgs; [
    s-tui
    stress
    r2modman
    alacritty
    appimage-run
    barrier
    bat
    bottom
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
    ludusavi
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
    picom
    pritunl-client
    protonup-qt
    rclone
    ripgrep
    rofi
    rustup
    snixembed
    soundux
    starship
    steamtinkerlaunch
    strace # system call monitoring
    stremio
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
    zoxide
    scrcpy
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
