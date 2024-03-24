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

  config = let
    group = config.users.users."${config.services.freshrss.user}".group;
  in
    lib.mkIf cfg.enable {
      sops.secrets = {
        "freshrss/admin_pwd" = {
          mode = "0440";
          group = group;
        };
        "freshrss/api_pwd" = {
          mode = "0440";
          group = group;
        };
      };

      services = {
        freshrss = {
          enable = true;

          baseUrl = cfg.url;
          passwordFile = config.sops.secrets."freshrss/admin_pwd".path;
          virtualHost = cfg.virtualHost;
        };

        nginx.virtualHosts =
          duckDnsLib.mkSubdomainFromPath
          config.services.freshrss.virtualHost {};
      };

      users.groups."${config.services.freshrss.user}".members = [config.users.users.homepage.name];
    };
}
