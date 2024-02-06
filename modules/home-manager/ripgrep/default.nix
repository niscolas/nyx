{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.ripgrep;
  configDir = "${config.nyx.modulesData.realPath}/ripgrep";
in {
  options.nyx.ripgrep = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ripgrep];

    home.file.".config/rg/.ripgreprc".source =
      if !cfg.enableDebugMode
      then ./.ripgreprc
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/.ripgreprc";
  };
}
