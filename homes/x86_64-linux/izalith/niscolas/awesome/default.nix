{
  config,
  lib,
  ...
}: let
  cfg = config.erdtree.niscolas.awesome;
in {
  options.erdtree.niscolas.awesome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awesome".source = ./config;
    erdtree.niscolas.stalonetray.enable = true;
  };
}
