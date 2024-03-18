{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.awesome;
in {
  options.nyx.awesome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [lightlocker];

    services.xserver = {
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

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    programs = {
      nm-applet.enable = true;
      xss-lock = {
        enable = true;
        lockerCommand = ''
          ${pkgs.lightlocker}/bin/light-locker-command -l
        '';
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
      };
    };

    security.polkit.enable = true;

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
