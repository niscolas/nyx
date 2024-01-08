{
  config,
  lib,
  ...
}: let
  cfg = config.erdtree.wired;
  configDirName = "wired";
  configDirPath = "${(import ../module-data.nix {inherit config;}).sourceConfigPath}/${configDirName}";
  configFileName = "wired.ron";
in {
  options.erdtree.wired = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."${configDirName}/${configFileName}".source =
      if !cfg.enableDebugMode
      then (import ./config.nix)
      else config.lib.file.mkOutOfStoreSymlink "${configDirPath}/${configFileName}";
  };
}
