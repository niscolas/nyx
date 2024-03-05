{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.alacritty;
  configDir = "${config.nyx.modulesData.realPath}/alacritty";
in {
  options.nyx.alacritty = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
    gruvbox = {
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [];

    home.file.".config/alacritty".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
