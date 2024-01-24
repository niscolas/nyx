{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.wezterm;
  configDir = "${config.nyx.modulesData.realPath}/wezterm";
in {
  options.nyx.wezterm = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [wezterm];

    home.file.".config/wezterm".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
