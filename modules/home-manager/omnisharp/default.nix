{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.omnisharp;
  configDir = "${config.nyx.modulesData.realPath}/omnisharp";
in {
  options.nyx.omnisharp = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [omnisharp-roslyn];

    home.file.".config/omnisharp/omnisharp.json".source =
      if !cfg.enableDebugMode
      then ./omnisharp.json
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/omnisharp.json";
  };
}
