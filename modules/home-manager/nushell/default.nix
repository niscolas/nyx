{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.nushell;
in {
  options.nyx.nushell = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  };
}
