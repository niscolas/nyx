{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.bottom;
  configDir = "${config.nyx.modulesData.realPath}/bottom";
in {
  options.nyx.bottom = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [bottom];

    home.file.".config/bottom/bottom.toml".source =
      if !cfg.enableDebugMode
      then ./bottom.toml
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/bottom.toml";
  };
}
