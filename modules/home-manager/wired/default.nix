{
  config,
  lib,
  ...
}: let
  cfg = config.erdtree.wired;
in {
  options.erdtree.wired = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."wired/wired.ron".source =
      if !cfg.enableDebugMode
      then (import ./config.nix)
      else
        config.lib.file.mkOutOfStoreSymlink
        "${config.erdtree.modulesData.realPath}/wired/wired.ron";
  };
}
