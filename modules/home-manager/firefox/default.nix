{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.firefox;
in {
  options.erdtree.firefox = {
    enable = lib.mkEnableOption {};
    enableStarship = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableTridactylNative = true;
        };
      };
    };
  };
}
