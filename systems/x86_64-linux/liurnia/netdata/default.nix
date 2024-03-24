{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.netdata;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
in {
  options.nyx.liurnia.netdata = {
    enable = lib.mkEnableOption {};
    service = {
      subdomain = duckDnsLib.mkServiceSubdomainOptionFromName "netdata";
      url = duckDnsLib.mkServiceUrlOptionFromSubdomain cfg.service.subdomain;
      port = duckDnsLib.mkServicePortOption "19999";
    };
  };

  config = lib.mkIf cfg.enable {
    services.netdata.enable = true;

    services.nginx.virtualHosts = (
      duckDnsLib.mkSubdomainFromPathAndPort cfg.service.subdomain cfg.service.port {}
    );
  };
}
