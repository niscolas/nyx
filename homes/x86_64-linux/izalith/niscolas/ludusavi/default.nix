{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.ludusavi;
  dotConfigDir = "${config.erdtree.home.configPath}/ludusavi/config";
in {
  options.erdtree.niscolas.ludusavi = {
    enable = lib.mkEnableOption {};
    targetConfigDir = lib.mkOption {
      type = lib.types.str;
      default = ".config/ludusavi";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ludusavi];

    home.file."${cfg.targetConfigDir}/cache.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotConfigDir}/cache.yaml";

    home.file."${cfg.targetConfigDir}/config.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotConfigDir}/config.yaml";

    home.file."${cfg.targetConfigDir}/manifest.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotConfigDir}/manifest.yaml";
  };
}
