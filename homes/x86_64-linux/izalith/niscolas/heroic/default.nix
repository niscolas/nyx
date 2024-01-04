{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.heroic;
  gameLaunchWrapper = pkgs.writeShellScriptBin "my-heroic-wrapper" ''
    export DXVK_NVAPI_ALLOW_OTHER_DRIVERS=1
    export DXVK_ENABLE_NVAPI=1
    export PROTON_ENABLE_NVAPI=1
    export VKD3D_FEATURE_LEVEL=12_0
    export DXVK_ASYNC=1 ENABLE_VKBASALT=1
    ${pkgs.gamemode}/bin/gamemoderun \
    ${pkgs.mangohud}/bin/mangohud \
    ${
      if cfg.enableLudusaviWrapper
      then "${pkgs.ludusavi}/bin/ludusavi --try-manifest-update --config $HOME/${config.erdtree.niscolas.ludusavi.targetConfigDir} wrap --gui --infer heroic --"
      else ""
    } \
      "$@"
  '';
in {
  options.erdtree.niscolas.heroic = {
    enable = lib.mkEnableOption {};
    enableLudusaviWrapper = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.heroic gameLaunchWrapper];
  };
}
