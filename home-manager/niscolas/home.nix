{ config, pkgs, ... }:

{
  home.username = "niscolas";
  home.homeDirectory = "/home/niscolas";

  home.file = {
    ".config/awesome".source = ./awesome;
    ".config/git".source = ./git;
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

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 120;
  };

  home.packages = with pkgs; [
    armcord
    barrier
    bat
    bottom
    cmake
    coreutils
    dbus
    delta
    discord
    easyeffects
    exa
    fd
    firefox
    flameshot
    fluent-reader
    fzf
    gamemode
    gamescope
    gcc
    git
    git-lfs
    glxinfo
    google-chrome
    heroic
    kanata
    libnotify
    logseq
    lua-language-server
    ludusavi
    lutris
    lxappearance
    mangohud
    mprocs
    neofetch
    networkmanagerapplet
    nodejs
    opensnitch-ui
    p7zip
    parsec-bin
    pavucontrol
    picom
    pritunl-client
    protonup-qt
    ripgrep
    rofi
    rustup
    starship
    stylua
    sunshine
    unzip
    vulkan-tools
    wezterm
    wget
    xclip
    xfce.thunar
    xfce.xfce4-power-manager
    xz
    zip
    zoxide

    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
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
