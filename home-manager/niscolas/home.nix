{ config, lib, pkgs, ... }:

{
  imports = [
    ./mangohud/init.nix
    ./nushell/init.nix
  ];

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
    ".config/eww".source = ./eww;
    ".config/flameshot".source = ./flameshot;
    ".config/gh".source = ./gh;
    ".config/git".source = ./git;
    ".config/hidamari".source = ./hidamari;
    ".config/i3".source = ./i3;
    ".config/ideavim".source = ./ideavim;
    ".config/keyd".source = ./keyd;
    ".config/ludusavi".source = ./ludusavi;
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
    tray.enable = true;
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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    };
  };

  home.packages = with pkgs; [
    armcord
    barrier
    bat
    bottom
    cmake
    dbus
    delta
    discord
    easyeffects
    exa
    fd
    flameshot
    fluent-reader
    fzf
    gamemode
    gamescope
    gcc
    git
    git-lfs
    glxinfo
    gnome.gnome-disk-utility
    google-chrome
    heroic
    inkscape-with-extensions
    kanata
    libnotify
    lm_sensors # for `sensors` command
    logseq
    lsof # list open files
    ltrace # library call monitoring
    lua-language-server
    ludusavi
    lutris
    lxappearance
    mangohud
    mprocs
    neofetch
    networkmanagerapplet
    nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
    nodejs
    opensnitch-ui
    p7zip
    parsec-bin
    pavucontrol
    pciutils # lspci
    picom
    pritunl-client
    protonup-qt
    ripgrep
    rofi
    rustup
    starship
    strace # system call monitoring
    stylua
    sunshine
    unzip
    usbutils # lsusb
    vulkan-tools
    wezterm
    wget
    xclip
    xz
    zip
    zoxide
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
