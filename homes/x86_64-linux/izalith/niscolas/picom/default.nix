{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.picom;
in {
  options.erdtree.niscolas.picom = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      picom
    ];

    xdg.configFile."picom/picom.conf".source =
      if !cfg.enableDebugMode
      then ./picom.conf
      else config.lib.file.mkOutOfStoreSymlink "${config.erdtree.niscolas.realPath}/picom/picom.conf";
  };
}
