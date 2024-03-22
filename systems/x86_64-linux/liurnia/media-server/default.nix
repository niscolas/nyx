{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.media-server;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
in {
  options.nyx.liurnia.media-server = {
    enable = lib.mkEnableOption {};

    jellyfin = {
      enable = lib.mkEnableOption {};

      virtualHost = lib.mkOption {
        type = lib.types.str;
        default = duckDnsLib.mkSubdomainPath "jellyfin";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://${cfg.jellyfin.virtualHost}";
      };

      port = lib.mkOption {
        type = lib.types.str;
        default = "8096";
      };
    };

    sonarr = {
      enable = lib.mkEnableOption {};

      virtualHost = lib.mkOption {
        type = lib.types.str;
        default = duckDnsLib.mkSubdomainPath "sonarr";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://${cfg.sonarr.virtualHost}";
      };

      port = lib.mkOption {
        type = lib.types.str;
        default = "8989";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin.enable = cfg.jellyfin.enable;
    services.sonarr.enable = cfg.sonarr.enable;

    services.nginx.virtualHosts =
      (
        if cfg.jellyfin.enable
        then duckDnsLib.mkSubdomainFromPathAndPort cfg.jellyfin.virtualHost cfg.jellyfin.port {}
        else {}
      )
      // (
        if cfg.sonarr.enable
        then duckDnsLib.mkSubdomainFromPathAndPort cfg.sonarr.virtualHost cfg.sonarr.port {}
        else {}
      );
  };
}
