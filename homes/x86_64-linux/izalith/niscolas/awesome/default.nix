{
  config,
  lib,
  outputs,
  ...
}: let
  cfg = config.nyx.niscolas.awesome;
in {
  imports = [
    ../picom
    outputs.homeManagerModules.autorandr
    outputs.homeManagerModules.wired
  ];

  options.nyx.niscolas.awesome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awesome".source = ./config;

    nyx = {
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
