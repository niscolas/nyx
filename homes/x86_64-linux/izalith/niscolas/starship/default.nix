{
  lib,
  config,
  ...
}: let
  cfg = config.erdtree.niscolas.starship;
in {
  options.erdtree.niscolas.starship = {
    enable = lib.mkEnableOption {};
    enableFishIntegration = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = cfg.enableFishIntegration;
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
