{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.freshrss;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
in {
  options.nyx.liurnia.freshrss = {
    enable = lib.mkEnableOption {};

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = duckDnsLib.mkSubdomainPath "freshrss";
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.services.freshrss.virtualHost}";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.freshrss_pwd.owner = config.services.freshrss.user;

    services = {
      freshrss = {
        enable = true;

        baseUrl = cfg.url;
        passwordFile = config.sops.secrets.freshrss_pwd.path;
        virtualHost = cfg.virtualHost;
      };

      nginx.virtualHosts =
        duckDnsLib.mkSubdomainFromPath
        config.services.freshrss.virtualHost {};
    };
  };
}
