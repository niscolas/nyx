{
  lib,
  config,
  ...
}: let
  cfg = config.nyx.liurnia.duckdns;
in {
  options.nyx.liurnia.duckdns = {
    enable = lib.mkEnableOption {};
    domainName = lib.mkOption {
      type = lib.types.str;
      default = "liurnia.duckdns.org";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.duckdns_token = {};

    security.acme = {
      defaults = {
      };

      certs."${config.nyx.liurnia.duckdns.domainName}" = {
        dnsProvider = "duckdns";

        credentialFiles = {
          DUCKDNS_TOKEN_FILE = config.sops.secrets.duckdns_token.path;
        };
        domain = "*.${config.nyx.liurnia.duckdns.domainName}";
        # extraDomainNames = ["*.${config.nyx.liurnia.duckdns.domainName}"];
      };
    };

    services.nginx.virtualHosts = {
      "${config.nyx.liurnia.duckdns.domainName}" = {
        # forceSSL = true;
        # enableACME = true;
        # acmeRoot = null;
        # serverAliases = ["*.${config.nyx.liurnia.duckdns.domainName}"];
      };
    };
  };
}
