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
        - My First Group:
            - My First Service:
                href: http://localhost/
                description: Homepage is awesome

        - RSS:
            - FreshRSS:
                href: ${config.nyx.liurnia.freshrss.url}
                description: RSS, but Fresh
      '';
    in {
      preStart = ''
        cp --force "${configFile}" "/var/lib/homepage-dashboard/services.yaml"
      '';
    };
  };
}
