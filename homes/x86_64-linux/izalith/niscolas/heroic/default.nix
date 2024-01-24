{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.niscolas.heroic;
  gameLaunchWrapper = pkgs.writeShellScriptBin "my-heroic-wrapper" ''
    DXVK_ASYNC=1 \
    ENABLE_VKBASALT=1 \
    DXVK_ENABLE_NVAPI=1 \
    DXVK_NVAPI_ALLOW_OTHER_DRIVERS=1 \
    PROTON_ENABLE_NVAPI=1 \
    VKD3D_CONFIG=dxr11,dxr \
    VKD3D_FEATURE_LEVEL=12_1 \
    ${pkgs.gamemode}/bin/gamemoderun \
    ${pkgs.mangohud}/bin/mangohud \
    ${
      if cfg.enableLudusaviWrapper
      then "${pkgs.ludusavi}/bin/ludusavi --try-manifest-update --config $HOME/${config.nyx.niscolas.ludusavi.targetConfigDir} wrap --gui --infer heroic --"
      else ""
    } \
    "$@"
  '';
in {
  options.nyx.niscolas.heroic = {
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
