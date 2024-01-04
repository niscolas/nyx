{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.erdtree.niscolas.eww;
  configDir = "${config.erdtree.home.configPath}/eww";
  launchEwwBar = pkgs.writeShellScriptBin "my-eww-bar" ''
    eww -c ~/.config/eww/bar open bar
  '';
in {
  options.erdtree.niscolas.eww = {
    enable = lib.mkEnableOption {};
    debugModeEnabled = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [eww launchEwwBar];

    home.file.".config/eww".source =
      if !cfg.debugModeEnabled
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
