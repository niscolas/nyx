{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "nextcloud/admin_pwd".owner = "nextcloud";
    "nextcloud/db_pwd".owner = "nextcloud";
  };

  services = {
    nextcloud = {
      enable = true;

      hostName = "nextcloud.${config.nyx.liurnia.duckdns.domainName}";
      https = true;
      package = pkgs.nextcloud28;
      database.createLocally = true;

      config = {
        overwriteProtocol = "https";

        adminuser = "admin";
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

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = "${config.nyx.liurnia.duckdns.domainName}";
      # enableACME = true;
      # acmeRoot = null;
    };
  };

  # systemd.services."nextcloud-setup" = {
  #   requires = ["postgresql.service"];
  #   after = ["postgresql.service"];
  # };
}
