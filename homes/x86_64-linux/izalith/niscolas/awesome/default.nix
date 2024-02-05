{
  config,
  lib,
  outputs,
  ...
}: let
  cfg = config.nyx.niscolas.awesome;
  configDir = "${config.nyx.niscolas.realPath}/awesome";
in {
  imports = [
    ../picom
    outputs.homeManagerModules.autorandr
    outputs.homeManagerModules.wired
  ];

  options.nyx.niscolas.awesome = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awesome".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";

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
