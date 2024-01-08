{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.picom;
  configDir = "${(import ../module-data.nix {inherit config;}).sourceConfigPath}/picom";
  configFile = "picom.conf";
in {
  options.erdtree.niscolas.picom = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      picom
    ];

    xdg.configFile."picom/${configFile}".source =
      if !cfg.enableDebugMode
      then "./${configFile}"
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/${configFile}";
  };
}
