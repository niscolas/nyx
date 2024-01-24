{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.niscolas.ludusavi;
  realConfigPath = "${config.nyx.niscolas.realPath}/ludusavi/config";
in {
  options.nyx.niscolas.ludusavi = {
    enable = lib.mkEnableOption {};
    targetConfigDir = lib.mkOption {
      type = lib.types.str;
      default = ".config/ludusavi";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ludusavi];

    home.file."${cfg.targetConfigDir}/cache.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${realConfigPath}/cache.yaml";

    home.file."${cfg.targetConfigDir}/config.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${realConfigPath}/config.yaml";

    home.file."${cfg.targetConfigDir}/manifest.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${realConfigPath}/manifest.yaml";
  };
}
