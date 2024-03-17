{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.pritunl;
in {
  options.nyx.pritunl = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [pritunl-client];

    systemd.services = {
      pritunl = {
        serviceConfig = {
          Type = "simple";
          User = "root";
        };
        script = "${pkgs.pritunl-client}/bin/pritunl-client-service";
        wantedBy = ["default.target"];
      };
    };
  };
}
