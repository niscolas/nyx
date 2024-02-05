{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.neofetch;
  configDir = "${config.nyx.modulesData.realPath}/neofetch";
in {
  options.nyx.neofetch = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [neofetch];

    home.file.".config/neofetch/config.conf".source =
      if !cfg.enableDebugMode
      then ./config.conf
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config.conf";
  };
}
