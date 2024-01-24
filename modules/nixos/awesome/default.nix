{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.awesome;
in {
  options.nyx.awesome = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };
}
