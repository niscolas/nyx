{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.erdtree.sunshine;
  sunshineOverride = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
in {
  options.erdtree.sunshine = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 47984;
          to = 48010;
        }
      ];

      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48010;
        }
      ];
    };

    environment.systemPackages = [
      sunshineOverride
    ];

    services.avahi = {
      enable = true;
      publish.userServices = true;
    };

    # sunshine = prev.sunshine.overrideAttrs (prev: {
    #   runtimeDependencies =
    #     prev.runtimeDependencies
    #     ++ [
    #       final.linuxKernel.packages.linux_zen.nvidia_x11
    #     ];
    # });

    security.wrappers = {
      # sunshine = {
      #   capabilities = "cap_sys_admin+p";
      #   group = "root";
      #   owner = "root";
      #   source = "${sunshineOverride}/bin/sunshine";
      # };

      # "sunshine-0.21.0" = {
      #   capabilities = "cap_sys_admin+p";
      #   group = "root";
      #   owner = "root";
      #   source = "${sunshineOverride}/bin/sunshine-0.21.0";
      # };
    };
  };
}
