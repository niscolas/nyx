{
  lib,
  config,
  ...
}: let
  cfg = config.nyx.eza;
in {
  options.nyx.eza = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
