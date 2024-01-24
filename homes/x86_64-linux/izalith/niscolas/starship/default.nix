{
  lib,
  config,
  ...
}: let
  cfg = config.nyx.niscolas.starship;
in {
  options.nyx.niscolas.starship = {
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
