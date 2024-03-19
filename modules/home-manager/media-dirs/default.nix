{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.media-dirs;
  storagePartitionRootPath = "/mnt/storage";
in {
  options.nyx.media-dirs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.downloads.enableSymlink;
    };

    downloads = {
      enableSymlink = lib.mkEnableOption {};
      sourcePath = lib.mkOption {
        type = lib.types.str;
        default = "${storagePartitionRootPath}/Downloads";
      };
    };

    videos = {
      enableSymlink = lib.mkEnableOption {};
      sourcePath = lib.mkOption {
        type = lib.types.str;
        default = "${storagePartitionRootPath}/Videos";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      "Downloads" = lib.mkIf cfg.downloads.enableSymlink {
        source =
          config.lib.file.mkOutOfStoreSymlink
          cfg.downloads.sourcePath;
      };

      "Videos" = lib.mkIf cfg.videos.enableSymlink {
        source =
          config.lib.file.mkOutOfStoreSymlink
          cfg.videos.sourcePath;
      };
    };
  };
}
