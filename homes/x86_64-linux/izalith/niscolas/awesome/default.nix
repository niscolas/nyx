{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  cfg = config.nyx.niscolas.awesome;
  configDir = "${config.nyx.niscolas.realPath}/awesome";

  defaultBg = pkgs.fetchurl {
    url = "https://images2.alphacoders.com/123/1239347.jpg";
    hash = "sha256-R136PjrVSx6DsK9Akw93NIN1xrIf+gqsuXDOXYCl42I=";
  };
in {
  imports = [
    ../picom
    outputs.homeManagerModules.autorandr
    outputs.homeManagerModules.emote
    outputs.homeManagerModules.wired
  ];

  options.nyx.niscolas.awesome = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awesome".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";

    xdg.configFile."wallpaper".source = config.lib.file.mkOutOfStoreSymlink defaultBg;

    nyx = {
      autorandr.enable = true;
      emote.enable = true;

      niscolas = {
        picom = {
          enable = true;
          enableDebugMode = true;
        };
      };

      wired = {
        enable = true;
        enableDebugMode = true;
      };
    };
  };
}
