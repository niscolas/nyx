{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  cfg = config.nyx.niscolas.awesome;
  configDir = "${config.nyx.niscolas.realPath}/awesome";

  defaultBg = pkgs.fetchurl {
    url = "https://images2.alphacoders.com/123/1239347.jpg";
    hash = "sha256-R136PjrVSx6DsK9Akw93NIN1xrIf+gqsuXDOXYCl42I=";
  };
in {
  imports = [
    ../eww
    ../picom
    outputs.homeManagerModules.autorandr
    outputs.homeManagerModules.emote
    outputs.homeManagerModules.wired
  ];

  options.nyx.niscolas.awesome = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
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
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Nordzy-cursors";
      size = 16;
      package = pkgs.nordzy-cursor-theme;
    };

    xdg.configFile."awesome".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";

    xdg.configFile."wallpaper".source = config.lib.file.mkOutOfStoreSymlink defaultBg;

    services = {
      blueman-applet.enable = true;
      network-manager-applet.enable = true;
    };

    nyx = {
      autorandr.enable = true;
      emote.enable = true;

      niscolas = {
        eww = {
          enable = false;
          enableDebugMode = true;
        };

        picom = {
          enable = true;
          enableDebugMode = true;
        };
      };

      wired = {
        enable = true;
        enableDebugMode = true;
      };
    };
  };
}
