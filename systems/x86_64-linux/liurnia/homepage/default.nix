{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.liurnia.homepage;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
  configDir = "/var/lib/homepage-dashboard";
in {
  # https://github.com/LongerHV/nixos-configuration/blob/3d9baf05bc1bc34e2b9137a475db123e84b7aec5/modules/nixos/homelab/homepage.nix#L4
  options.nyx.liurnia.homepage = with lib; {
    enable = mkEnableOption {};

    service = {
      port = duckDnsLib.mkServicePortOption (toString (config.services.homepage-dashboard.listenPort));
    };

    layout = {
      settings = mkOption {
        type = types.attrs;
        default = {};
      };

      services = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };

      widgets = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };

      bookmarks = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      homepage-dashboard = {
        enable = true;
        package = pkgs.unstable.homepage-dashboard;
      };

      nginx.virtualHosts = {
        "${config.nyx.liurnia.duckdns.domainName}" =
          duckDnsLib.commonConfig
          // {
            locations."/".proxyPass = "http://localhost:${cfg.service.port}";
          };
      };
    };

    systemd.services.homepage-dashboard = let
      generate = (pkgs.formats.yaml {}).generate;
    in {
      preStart = ''
        ln -sf ${generate "settings.yaml" cfg.layout.settings} ${configDir}/settings.yaml
        ln -sf ${generate "services.yaml" cfg.layout.services} ${configDir}/services.yaml
        ln -sf ${generate "widgets.yaml" cfg.layout.widgets} ${configDir}/widgets.yaml
        ln -sf ${generate "bookmarks.yaml" cfg.layout.bookmarks} ${configDir}/bookmarks.yaml
      '';
    };
  };
}
