{
  lib,
  config,
  ...
}: let
  cfg = config.erdtree.izalith.autorandr;
in {
  options.erdtree.izalith.autorandr = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services.autorandr = {
      enable = true;
    };
  };
}
