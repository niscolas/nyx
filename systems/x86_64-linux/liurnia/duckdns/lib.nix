{
  config,
  lib,
  ...
}:
with lib; rec {
  commonConfig = {
    forceSSL = true;
    useACMEHost = config.nyx.liurnia.duckdns.domainName;
  };

  mkSubdomainPath = subpath: "${subpath}.${config.nyx.liurnia.duckdns.domainName}";

  mkSubdomain = name: extraConfig: {
    "${mkSubdomainPath name}" = recursiveUpdate commonConfig extraConfig;
  };

  mkSubdomainFromPath = path: extraConfig: {
    "${path}" = recursiveUpdate commonConfig extraConfig;
  };

  mkSubdomainFromPathAndPort = path: port: extraConfig: {
    "${path}" = recursiveUpdate (commonConfig
      // {
        locations."/".proxyPass = "http://localhost:${port}";
      })
    extraConfig;
  };

  mkSubdomainFromNameAndPort = name: port: extraConfig: {
    "${mkSubdomainPath name}" = recursiveUpdate (commonConfig
      // {
        locations."/".proxyPass = "http://localhost:${port}";
      })
    extraConfig;
  };

  mkServiceUrlOptionFromSubdomain = subdomain:
    mkOption {
      type = types.str;
      default = "https://${subdomain}";
    };

  mkServiceSubdomainOptionFromName = name:
    mkOption {
      type = types.str;
      default = mkSubdomainPath name;
    };

  mkServicePortOption = port:
    mkOption {
      type = types.str;
      default = port;
    };
}
