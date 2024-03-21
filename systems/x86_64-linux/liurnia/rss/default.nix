{
  config,
  inputs,
  ...
}: let
  freshrss = {
    address = "freshrss.${config.nyx.liurnia.duckdns.domainName}";
    user = "freshrss";
  };
in {
  sops.secrets = {
    freshrss_pwd = {
      owner = "${freshrss.user}";
    };
  };

  services = {
    freshrss = {
      enable = true;

      user = "${freshrss.user}";
      baseUrl = "https://${freshrss.address}";
      defaultUser = "admin";
      passwordFile = config.sops.secrets.freshrss_pwd.path;
      virtualHost = "${freshrss.address}";
    };

    nginx.virtualHosts.${config.services.freshrss.virtualHost} = {
      forceSSL = true;
      useACMEHost = "${config.nyx.liurnia.duckdns.domainName}";
      # enableACME = true;
      # acmeRoot = null;
    };
  };

  virtualisation.oci-containers.containers.fivefilters-full-text-rss = {
    image = "heussd/fivefilters-full-text-rss:latest";

    environment = {
      # Leave empty to disable admin section
      # FTR_ADMIN_PASSWORD = "";
    };

    volumes = ["rss-cache:/var/lib/fivefilters-cache"];
    ports = ["801:80"];
  };
}
