{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.starship;
in {
  options.starship = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = config.programs.starship.enableFishIntegration;
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
