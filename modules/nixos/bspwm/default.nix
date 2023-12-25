{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.bspwm;
in {
  options.erdtree.bspwm = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.bspwm.enable = true;
  };
}
