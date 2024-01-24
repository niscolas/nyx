{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.bspwm;
in {
  options.nyx.bspwm = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.bspwm.enable = true;
  };
}
