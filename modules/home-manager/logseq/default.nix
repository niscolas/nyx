{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.logseq;
  configDir = "${config.nyx.modulesData.realPath}/logseq";
  logseqBackup = pkgs.writeShellApplication {
    name = "${unitName}";
    runtimeInputs = [pkgs.coreutils pkgs.git pkgs.openssh];
    text = builtins.readFile ./${unitName}.sh;
  };
  unitName = "logseq-backup";
in {
  options.nyx.logseq = {
    enable = lib.mkEnableOption {};
    enableBackup = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    systemd.user =
      lib.mkIf cfg.enableBackup
      {
        services.${unitName} = {
          Install.WantedBy = ["default.target"];
          Service = {
            Type = "oneshot";
            ExecStart = "${logseqBackup}/bin/${unitName}";
          };
        };

        timers.${unitName} = {
          Install.WantedBy = ["timers.target"];
          Timer = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
            Unit = "${unitName}.service";
          };
        };
      };

    home = {
      file = {
        ".logseq/config".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/config";
        ".logseq/preferences.json".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/preferences.json";
        ".logseq/settings".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/settings";
      };

      packages = with pkgs; [logseq];
    };
  };
}