{
  lib,
  config,
  outputs,
  pkgs,
  ...
}: let
  cfg = config.nyx.gnome;
in {
  options.nyx.gnome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    # orca - a scriptable screen reader
    environment = {
      gnome.excludePackages =
        (with pkgs; [
          gnome-console
          gnome-text-editor
          gnome-tour
          orca # "a scriptable screen reader"
        ])
        ++ (with pkgs.gnome; [
          atomix # puzzle game
          cheese # webcam tool
          epiphany # web browser
          evince # document viewer
          geary # email
          geary # email reader
          gedit # text editor
          gnome-characters
          gnome-music
          gnome-terminal
          hitori # sudoku game
          iagno # go game
          tali # poker game
          totem # video player
        ]);

      systemPackages = with pkgs;
        []
        ++ (with gnome; [
          gnome-tweaks
        ])
        ++ (with gnomeExtensions; [
          appindicator
          dash-to-panel
          forge
        ]);
    };

    services = {
      xserver.displayManager.gdm.enable = true;
      xserver.desktopManager.gnome.enable = true;

      udev.packages = with pkgs.gnome; [gnome-settings-daemon];
    };

    programs.dconf.profiles = {
      user.databases = [
        {
          settings = with lib.gvariant; {
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";
            "org/gnome/desktop/interface".show-battery-percentage = true;

            "org/gnome/shell".enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "dash-to-panel@jderose9.github.com"
              "forge@jmmaranan.com"
            ];

            "org/gnome/desktop/wm/keybindings" = {
              switch-to-workspace-left = mkEmptyArray type.string;
              switch-to-workspace-right = mkEmptyArray type.string;
              move-to-workspace-left = mkEmptyArray type.string;
              move-to-workspace-right = mkEmptyArray type.string;
              switch-to-workspace-1 = ["<Super>1"];
              switch-to-workspace-2 = ["<Super>2"];
              switch-to-workspace-3 = ["<Super>3"];
              switch-to-workspace-4 = ["<Super>4"];
              switch-to-workspace-5 = ["<Super>5"];
              switch-to-workspace-6 = ["<Super>6"];
              switch-to-workspace-7 = ["<Super>7"];
              switch-to-workspace-8 = ["<Super>8"];
              switch-to-workspace-9 = ["<Super>9"];
              switch-to-workspace-10 = ["<Super>0"];
              move-to-workspace-1 = ["<Super><Shift>1"];
              move-to-workspace-2 = ["<Super><Shift>2"];
              move-to-workspace-3 = ["<Super><Shift>3"];
              move-to-workspace-4 = ["<Super><Shift>4"];
              move-to-workspace-5 = ["<Super><Shift>5"];
              move-to-workspace-6 = ["<Super><Shift>6"];
              move-to-workspace-7 = ["<Super><Shift>7"];
              move-to-workspace-8 = ["<Super><Shift>8"];
              move-to-workspace-9 = ["<Super><Shift>9"];
              move-to-workspace-10 = ["<Super><Shift>0"];
              switch-to-application-1 = mkEmptyArray type.string;
              switch-to-application-2 = mkEmptyArray type.string;
              switch-to-application-3 = mkEmptyArray type.string;
              switch-to-application-4 = mkEmptyArray type.string;
              switch-to-application-5 = mkEmptyArray type.string;
              switch-to-application-6 = mkEmptyArray type.string;
              switch-to-application-7 = mkEmptyArray type.string;
              switch-to-application-8 = mkEmptyArray type.string;
              switch-to-application-9 = mkEmptyArray type.string;
              switch-to-application-10 = mkEmptyArray type.string;
              switch-input-source = ["<Super>,"];
              switch-input-source-backward = mkEmptyArray type.string;
              activate-window-menu = ["Menu"];
              close = ["<Super>q"];
              toggle-fullscreen = ["<Super>f"];
            };
          };
        }
      ];
    };
  };
}
