{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.batcat;
  configDir = "${config.nyx.modulesData.realPath}/batcat";
in {
  options.nyx.batcat = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [bat];

    home.file.".config/bat/config".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
