{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.erdtree.starship;
in {
  options.erdtree.starship = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = config.programs.starship.enableFishIntegration;
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
