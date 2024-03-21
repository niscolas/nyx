{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.nyx.liurnia.performance;
in {
  options.nyx.liurnia.performance = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      map lib.lowPrio [
        powertop
      ];

    powerManagement.powertop.enable = true;

    services = {
      system76-scheduler.enable = true;
      auto-cpufreq.enable = true;
    };
  };
}
