{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.zsh;
  configDir = "${config.nyx.modulesData.realPath}/zsh";
in {
  options.nyx.zsh = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [zsh];

    home.file.".config/zsh".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
