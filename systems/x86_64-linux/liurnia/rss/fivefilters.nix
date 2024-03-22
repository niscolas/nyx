{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.fivefilters;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
  port = "801";
in {
  options.nyx.liurnia.fivefilters = rec {
    enable = lib.mkEnableOption {};

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = duckDnsLib.mkSubdomainPath "fivefilters";
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.nyx.liurnia.fivefilters.virtualHost}";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.fivefilters-full-text-rss = {
      image = "heussd/fivefilters-full-text-rss:latest";

      environment = {
        # Leave empty to disable admin section
        # FTR_ADMIN_PASSWORD = "";
      };

      volumes = ["rss-cache:/var/lib/fivefilters-cache"];
      ports = ["${port}:80"];
    };

    services.nginx.virtualHosts =
      duckDnsLib.mkSubdomainFromPath
      cfg.virtualHost {
        locations."/".proxyPass = "http://localhost:${port}";
      };
  };
}
