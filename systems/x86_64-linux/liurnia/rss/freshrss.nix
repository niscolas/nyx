{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.freshrss;
in {
  options.nyx.liurnia.freshrss = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.freshrss_pwd.owner = config.services.freshrss.user;

    services = {
      freshrss = {
        enable = true;

        baseUrl = "https://${config.services.freshrss.virtualHost}";
        passwordFile = config.sops.secrets.freshrss_pwd.path;
        virtualHost = "freshrss.${config.nyx.liurnia.duckdns.domainName}";
      };

      nginx.virtualHosts.${config.services.freshrss.virtualHost} = {
        forceSSL = true;
        useACMEHost = config.nyx.liurnia.duckdns.domainName;
        # enableACME = true;
        # acmeRoot = null;
      };
    };
  };
}
