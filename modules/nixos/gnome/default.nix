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
    environment.systemPackages = with pkgs; [gnomeExtensions.forge];
    services = {
      xserver.displayManager.gdm.enable = true;
      xserver.desktopManager.gnome.enable = true;
    };
  };
}
