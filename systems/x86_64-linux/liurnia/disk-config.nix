{...}: let
  systemPoolName = "zsystem";
  storagePool = {
    name = "zstorage";
    mountpoint = "/${storagePool.name}";
    data = {
      name = "data";
      mountpoint = "${storagePool.mountpoint}/${storagePool.data.name}";
    };
    backup = {
      name = "backup";
      mountpoint = "${storagePool.mountpoint}/${storagePool.backup.name}";
    };
    temp = {
      name = "temp";
      mountpoint = "${storagePool.mountpoint}/${storagePool.temp.name}";
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
      hdd1 = {
        type = "disk";
        device = "/dev/sda";
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
      hdd2 = {
        type = "disk";
        device = "/dev/sdb";
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
    };
    zpool = {
      ${systemPoolName} = {
        type = "zpool";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/disk.key";
        };
        mountpoint = "/";

        postCreateHook = ''
          zfs set keylocation="prompt" ${systemPoolName};
          zfs snapshot ${systemPoolName}@blank;
        '';

        datasets = {
          system_fs = {
            type = "zfs_fs";
            mountpoint = "/system_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };

      ${storagePool.name} = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/disk.key";
        };
        mountpoint = "/${storagePool.name}";

        postCreateHook = ''
          zfs set keylocation="prompt" ${storagePool.name};
          zfs snapshot ${storagePool.name}@blank;
        '';

        datasets = {
          "${storagePool.data.name}" = {
            type = "zfs_fs";
            mountpoint = "${storagePool.data.mountpoint}";
            options."com.sun:auto-snapshot" = "true";
          };

          "${storagePool.backup.name}" = {
            type = "zfs_fs";
            mountpoint = "${storagePool.backup.mountpoint}";
            options."com.sun:auto-snapshot" = "true";
          };

          "${storagePool.temp.name}" = {
            type = "zfs_fs";
            mountpoint = "${storagePool.temp.mountpoint}";
          };
        };
      };
    };
  };
}
