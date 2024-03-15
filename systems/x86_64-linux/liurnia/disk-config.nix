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
          "${storagePool.data.name}" = withAutoSnapshot (datasetMountablePostCreate storagePool.data
            // {
              options = {
                sharenfs = "on";
              };
            });

          "${storagePool.backup.name}" =
            withAutoSnapshot (datasetMountablePostCreate storagePool.backup);

          "${storagePool.temp.name}" =
            datasetMountablePostCreate storagePool.temp;
        };
      };
    };
  };

  boot.zfs = {
    # enabled = true;
    forceImportAll = false;
    requestEncryptionCredentials = true;
  };

  # systemd.services."zfs-import-${storagePool.name}".wantedBy = lib.mkForce ["multi-user.target"];

  # systemd = {
  #   services.setupStoragePool = {
  #     description = "Setup ZFS Storage Pool";
  #     wantedBy = ["multi-user.target"]; # Run at multi-user.target for manual user interaction
  #
  #     script = ''
  #       ${pkgs.zfs}/bin/zpool import ${storagePool.name}
  #
  #       # Maximum number of retries
  #       max_retries=3
  #       retry_count=0
  #
  #       # Loop until successful or maximum retries reached
  #       while [ $retry_count -lt $max_retries ]; do
  #           # Prompt for passphrase
  #           read -rsp "Enter passphrase for ZFS encryption (attempt $((retry_count + 1)) of $max_retries): " passphrase
  #           echo    # Newline after passphrase
  #           # Attempt to load the encryption key
  #           sudo zfs load-key -L - <<<"$passphrase" ${storagePool.name}
  #           # Check if loading key was successful
  #           if [ $? -eq 0 ]; then
  #               echo "Encryption key loaded successfully."
  #               break  # Exit loop if successful
  #           else
  #               echo "Failed to load encryption key. Retrying..."
  #               retry_count=$((retry_count + 1))
  #           fi
  #       done
  #       # Check if maximum retries reached
  #       if [ $retry_count -eq $max_retries ]; then
  #           echo "Maximum number of retries reached. Exiting."
  #           exit 1  # Exit with failure
  #       fi
  #
  #       ${pkgs.zfs}/bin/zfs mount -a
  #       # ${pkgs.zfs}/bin/zfs mount ${storagePool.data.fullName}
  #       # ${pkgs.zfs}/bin/zfs mount ${storagePool.backup.fullName}
  #       # ${pkgs.zfs}/bin/zfs mount ${storagePool.temp.fullName}
  #     '';
  #   };
  # };
}
