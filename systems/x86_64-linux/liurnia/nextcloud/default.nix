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

  config = let
    group = config.users.groups.nextcloud.name;
  in
    lib.mkIf cfg.enable {
      sops.secrets = {
        "nextcloud/admin_pwd" = {
          inherit group;
          mode = "0440";
        };

        "nextcloud/db_pwd" = {
          inherit group;
          mode = "0440";
        };

        "nextcloud/nc_token" = {
          inherit group;
          mode = "0440";
        };
      };

      services = {
        nextcloud = {
          enable = true;

          hostName = cfg.virtualHost;
          home = "/zstorage/nextcloud/home";
          https = true;
          package = pkgs.nextcloud28;
          database.createLocally = true;

          config = {
            overwriteProtocol = "https";

            adminuser = "admin";
            adminpassFile = config.sops.secrets."nextcloud/admin_pwd".path;

            dbtype = "pgsql";
          };

          extraAppsEnable = true;

          extraApps = {
            inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
          };
        };

        nginx.virtualHosts = duckDnsLib.mkSubdomainFromPath config.services.nextcloud.hostName {};
      };

      users.groups.nextcloud.members = [config.users.users.homepage.name];

      systemd.services."nextcloud-setup" = {
        requires = ["zfs-import-zstorage.service"];
        after = ["zfs-import-zstorage.service"];
      };
    };
}
