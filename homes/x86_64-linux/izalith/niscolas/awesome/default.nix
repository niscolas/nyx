{
  config,
  lib,
  outputs,
  ...
}: let
  cfg = config.erdtree.niscolas.awesome;
in {
  imports = [
    ../picom
    outputs.homeManagerModules.autorandr
    outputs.homeManagerModules.wired
  ];

  options.erdtree.niscolas.awesome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awesome".source = ./config;

    erdtree = {
      niscolas = {
        picom = {
          enable = true;
          enableDebugMode = true;
        };
      };

      autorandr.enable = true;

      wired = {
        enable = true;
        enableDebugMode = true;
      };
    };
  };
}
