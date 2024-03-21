{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.fivefilters;
in {
  options.nyx.liurnia.fivefilters = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.fivefilters-full-text-rss = {
      image = "heussd/fivefilters-full-text-rss:latest";

      environment = {
        # Leave empty to disable admin section
        # FTR_ADMIN_PASSWORD = "";
      };

      volumes = ["rss-cache:/var/lib/fivefilters-cache"];
      ports = ["801:80" "809:443"];
    };

    services.nginx.virtualHosts."fivefilters.${config.nyx.liurnia.duckdns.domainName}" = {
      locations."/".proxyPass = "https://localhost:809";
      forceSSL = true;
      useACMEHost = "${config.nyx.liurnia.duckdns.domainName}";
    };
  };
}
