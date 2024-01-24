{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.niscolas.eww;
  configDir = "${config.nyx.niscolas.realPath}/eww";
  launchBarBin = import ./launch-bar.nix {inherit pkgs;};
  clockBin = pkgs.writeShellScriptBin "my-eww-bar-clock" ''
    date +'%a,%e de %b. (%m), 󰥔 %H:%M'
  '';
in {
  options.nyx.niscolas.eww = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [eww launchBarBin clockBin];

    home.file.".config/eww".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
