{
  lib,
  config,
  ...
}: let
  cfg = config.nyx.starship;
in {
  options.nyx.starship = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };

    # TODO: use programs.starship.settings instead
    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
