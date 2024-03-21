{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.fivefilters;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
  port = "801";
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
      ports = ["${port}:80"];
    };

    services.nginx.virtualHosts =
      duckDnsLib.mkSubdomain
      "fivefilters" {
        locations."/".proxyPass = "http://localhost:${port}";
      };
  };
}
