{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.alacritty.gruvboxDark;
in {
  options.nyx.alacritty.gruvboxDark = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
    gruvbox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      font.size = lib.mkOption {
        type = lib.types.int;
        default = 14;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [alacritty];

    home.file.".config/alacritty".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";
  };
}
