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

    # TODO: include also the group that the "homepage" user should be added to access it
    secrets = mkOption {
      type = types.attrs;
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
      files = ["settings" "services" "widgets" "bookmarks"];
      sedCommand =
        builtins.concatStringsSep "; "
        (
          builtins.attrValues
          (
            builtins.mapAttrs (keyword: file: "s/${keyword}/$(<${file})/g")
            cfg.secrets
          )
        );
    in {
      preStart =
        builtins.concatStringsSep
        "\n"
        (
          map
          (file: ''
            original=${generate "${file}.yaml" cfg.layout.${file}}
            copy=${configDir}/${file}.yaml
            cp -f $original $copy
            sed -i "${sedCommand}" $copy
          '')
          files
        );

      serviceConfig = {
        User = config.users.users.homepage.name;
      };
    };

    users = {
      users = {
        homepage = {
          group = config.users.groups.homepage.name;
          isSystemUser = true;
        };
      };

      groups.homepage = {};
    };
  };
}
