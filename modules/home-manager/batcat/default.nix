{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.batcat;
in {
  options.nyx.batcat = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
  };
}
