{
  lib,
  pkgs,
  ...
}: let
  systemPoolName = "zsystem";
  storagePool = rec {
    name = "zstorage";
    mountpoint = "/${name}";

    datasetSettings = datasetName: {
      name = datasetName;
      fullName = "${name}/${datasetName}";
      mountpoint = "${mountpoint}/${datasetName}";
    };

    data = datasetSettings "data";
    backup = datasetSettings "backup";
    temp = datasetSettings "temp";
  };

  dataset = mountpoint: {
    type = "zfs_fs";
    inherit mountpoint;
  };

  encryptedDataset = datasetSettings:
    dataset datasetSettings.mountpoint
    // {
      options = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "file:///tmp/disk.key";
      };

      postCreateHook = ''
        zfs set keylocation="prompt" ${datasetSettings.fullName};
        zfs snapshot ${datasetSettings.fullName}@blank;
      '';
    };

  withNoAutoMount = {
    options = {
      canmount = "noauto";
    };
  };

  withAutoSnapshot = {
    options = {
      "com.sun:auto-snapshot" = "true";
    };
  };

  mirroredHdd = device: {
    type = "disk";
    device = "${device}";
    content = {
      type = "gpt";
      partitions = {
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "${storagePool.name}";
          };
        };
      };
    };
  };
in {
  disko.devices = {
    disk = {
      ssd = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "${systemPoolName}";
              };
            };
          };
        };
      };
      hdd1 = mirroredHdd "/dev/sda";
      hdd2 = mirroredHdd "/dev/sdb";
    };
    zpool = {
      ${systemPoolName} = {
        type = "zpool";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          compression = "zstd";
        };
        mountpoint = "/";

        postCreateHook = ''
          zfs snapshot ${systemPoolName}@blank;
        '';

        datasets.system_fs = dataset "/system_fs" // withAutoSnapshot;
      };

      ${storagePool.name} = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          canmount = "off";
          compression = "zstd";
          keylocation = "none";
          mountpoint = "none";
        };
        # mountpoint = "/${storagePool.name}";

        datasets = {
          "${storagePool.data.name}" = lib.recursiveUpdate (encryptedDataset storagePool.data) (lib.recursiveUpdate withNoAutoMount withAutoSnapshot);
          "${storagePool.backup.name}" = lib.recursiveUpdate (encryptedDataset storagePool.backup) (lib.recursiveUpdate withNoAutoMount withAutoSnapshot);
          "${storagePool.temp.name}" = lib.recursiveUpdate (encryptedDataset storagePool.temp) withNoAutoMount;
        };
      };
    };
  };

  # systemd = {
  #   services.mountZfsDatasets = {
  #     description = "Mount ZFS datasets";
  #     wantedBy = ["multi-user.target"]; # Run at multi-user.target for manual user interaction
  #
  #     script = ''
  #       ${pkgs.zfs}/bin/zfs mount ${storagePool.data.mountpoint}
  #       ${pkgs.zfs}/bin/zfs mount ${storagePool.backup.mountpoint}
  #       ${pkgs.zfs}/bin/zfs mount ${storagePool.temp.mountpoint}
  #     '';
  #   };
  # };
}
