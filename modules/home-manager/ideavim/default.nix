{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.ideavim;
  configDir = "${config.nyx.modulesData.realPath}/ideavim";
in {
  options.nyx.ideavim = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/ideavim/ideavimrc".source =
      if !cfg.enableDebugMode
      then ./ideavimrc
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/ideavimrc";
  };
}
