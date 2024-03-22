{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.nyx.liurnia.fgc;
  duckDnsLib = import ../duckdns/lib.nix {inherit config lib;};
  port = "6080";
  envFileDir = "/var/lib/fgc";
  envFilePath = "${envFileDir}/.env";
in {
  options.nyx.liurnia.fgc = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "fgc/eg/email" = {};
      "fgc/eg/pwd" = {};
      "fgc/eg/otpkey" = {};
    };

    systemd.services = let
      setupFgcEnvServiceName = "setup-fgc-env";
    in {
      podman-fgc = {
        requires = ["${setupFgcEnvServiceName}.service"];
        after = ["${setupFgcEnvServiceName}.service"];
      };

      "${setupFgcEnvServiceName}" = {
        script = ''
          mkdir -p ${envFileDir}
          echo "
          EG_EMAIL=$(cat ${config.sops.secrets."fgc/eg/email".path})
          EG_PASSWORD=$(cat ${config.sops.secrets."fgc/eg/pwd".path})
          EG_OTPKEY=$(cat ${config.sops.secrets."fgc/eg/otpkey".path})
          " > ${envFilePath}
        '';
      };
    };

    virtualisation.oci-containers.containers.fgc = {
      image = "ghcr.io/vogler/free-games-claimer:main";
      environmentFiles = [envFilePath];
      extraOptions = ["--pull=always"];
      volumes = ["fgc:/var/lib/fgc/data"];
      ports = ["${port}:${port}"];
    };

    services.nginx.virtualHosts =
      duckDnsLib.mkSubdomain
      "fgc" {
        locations."/".proxyPass = "http://localhost:${port}";
      };
  };
}
