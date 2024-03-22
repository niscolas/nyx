{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.liurnia.homepage;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
in {
  options.nyx.liurnia.homepage = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services = {
      homepage-dashboard.enable = true;

      nginx.virtualHosts = {
        "${config.nyx.liurnia.duckdns.domainName}" =
          duckDnsLib.commonConfig
          // {
            locations."/".proxyPass = "http://localhost:${toString (config.services.homepage-dashboard.listenPort)}";
          };
      };
    };

    systemd.services.homepage-dashboard = let
      configFile = pkgs.writeText "services.yaml" ''
        - Stuff?:
            - NextCloud:
                icon: nextcloud.svg
                description: Afte Cloud...
                href: ${config.nyx.liurnia.nextcloud.url}
                ping: ${config.nyx.liurnia.nextcloud.virtualHost}

        - RSS:
            - FreshRSS:
                icon: freshrss.svg
                description: RSS, but Fresh.
                href: ${config.nyx.liurnia.freshrss.url}
                ping: ${config.nyx.liurnia.freshrss.virtualHost}

            - Five Filters:
                icon: freshrss.svg
                description: It actually uses 5 entire filters.
                href: ${config.nyx.liurnia.fivefilters.url}
                ping: ${config.nyx.liurnia.fivefilters.virtualHost}
      '';
    in {
      preStart = ''
        cp --force "${configFile}" "/var/lib/homepage-dashboard/services.yaml"
      '';
    };
  };
}
