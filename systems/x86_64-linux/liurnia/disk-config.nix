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
    nextcloud = datasetSettings "nextcloud";
    backup = datasetSettings "backup";
    temp = datasetSettings "temp";
  };

  dataset = mountpoint: {
    type = "zfs_fs";
    inherit mountpoint;
  };

  datasetMountablePostCreate = datasetSettings:
    dataset null
    // {
      options = {
        mountpoint = "none";
        canmount = "noauto";
      };

      postCreateHook = ''
        zfs set mountpoint=${datasetSettings.mountpoint} ${datasetSettings.fullName};
      '';
    };

  withAutoSnapshot = dataset:
    lib.recursiveUpdate
    dataset {
      options = {auto-snapshot = "true";};
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

        datasets.system_fs = withAutoSnapshot (dataset "/system_fs");
      };

      ${storagePool.name} = {
        type = "zpool";
        mode = "mirror";

        mountpoint = null;
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          canmount = "off";
          compression = "zstd";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/disk.key";
        };

        postCreateHook = ''
          zfs set keylocation="prompt" ${storagePool.name};
          zfs snapshot ${storagePool.name}@blank;
        '';

        datasets = {
          "${storagePool.data.name}" = withAutoSnapshot (dataset storagePool.data.mountpoint
            // {
              options = {
                sharenfs = "on";
              };
            });

          "${storagePool.nextcloud.name}" = withAutoSnapshot (dataset storagePool.nextcloud.mountpoint);
          "${storagePool.backup.name}" = withAutoSnapshot (dataset storagePool.backup.mountpoint);
          "${storagePool.temp.name}" = dataset storagePool.temp.mountpoint;
        };
      };
    };
  };

  boot.zfs = {
    # enabled = true;
    forceImportAll = false;
    requestEncryptionCredentials = true;
  };

  systemd.services."zfs-import-${storagePool.name}" = {
    after = ["sshd.service"];
  };
}
