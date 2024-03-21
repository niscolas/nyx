{
  config,
  lib,
  ...
}: rec {
  commonConfig = {
    forceSSL = true;
    useACMEHost = config.nyx.liurnia.duckdns.domainName;
  };

  mkSubdomainPath = subpath: "${subpath}.${config.nyx.liurnia.duckdns.domainName}";

  mkSubdomain = subpath: extraConfig: {
    "${mkSubdomainPath subpath}" = lib.recursiveUpdate commonConfig extraConfig;
  };

  mkSubdomainFromPath = path: extraConfig: {
    "${path}" = lib.recursiveUpdate commonConfig extraConfig;
  };
}
