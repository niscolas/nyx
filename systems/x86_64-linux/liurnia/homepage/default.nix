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
      format = pkgs.formats.yaml {};
    in {
      preStart = ''
        ln -sf ${format.generate "settings.yaml" cfg.settings} ${configDir}/settings.yaml
        ln -sf ${format.generate "services.yaml" cfg.services} ${configDir}/services.yaml
        ln -sf ${format.generate "widgets.yaml" cfg.widgets} ${configDir}/widgets.yaml
        ln -sf ${format.generate "bookmarks.yaml" cfg.bookmarks} ${configDir}/bookmarks.yaml
      '';
    };
  };
}
