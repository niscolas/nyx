{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.liurnia.nextcloud;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
in {
  options.nyx.liurnia.nextcloud = {
    enable = lib.mkEnableOption {};

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = duckDnsLib.mkSubdomainPath "nextcloud";
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.services.nextcloud.hostName}";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/admin_pwd".owner = "nextcloud";
      "nextcloud/db_pwd".owner = "nextcloud";
    };

    services = {
      nextcloud = {
        enable = true;

        hostName = cfg.virtualHost;
        home = "/zstorage/data/nextcloud";
        https = true;
        package = pkgs.nextcloud28;
        database.createLocally = true;

        config = {
          overwriteProtocol = "https";

          adminuser = "niscolas";
          adminpassFile = config.sops.secrets."nextcloud/admin_pwd".path;

          dbtype = "pgsql";
          # dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
          # dbpassFile = config.sops.secrets."nextcloud/db_pwd".path;
        };

        extraAppsEnable = true;

        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
        };
      };

      # postgresql = {
      #   enable = true;
      #
      #   # Ensure the database, user, and permissions always exist
      #   ensureDatabases = ["nextcloud"];
      #   ensureUsers = [
      #     {
      #       name = "nextcloud";
      #       ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      #     }
      #   ];
      # };

      nginx.virtualHosts = duckDnsLib.mkSubdomainFromPath config.services.nextcloud.hostName {};
    };

    systemd.services."nextcloud-setup" = {
      requires = ["zfs-import-zstorage.service"];
      after = ["zfs-import-zstorage.service"];
    };
  };
}
