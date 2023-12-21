{
  config,
  pkgs,
  ...
}: let
  configDir = "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas/logseq";
  logseqBackup = pkgs.writeShellApplication {
    name = "${unitName}";
    runtimeInputs = [pkgs.git pkgs.openssh];
    text = builtins.readFile ./${unitName}.sh;
  };
  unitName = "logseq-backup";
in {
  systemd.user.services.${unitName} = {
    Install.WantedBy = ["default.target"];
    Service = {
      Type = "oneshot";
      ExecStart = "${logseqBackup}/bin/${unitName}";
    };
  };

  systemd.user.timers.${unitName} = {
    Install.WantedBy = ["timers.target"];
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "${unitName}.service";
    };
  };

  home.packages = with pkgs; [logseq];

  home.file = {
    ".logseq/config".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/config";
    ".logseq/settings".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/settings";
    ".logseq/preferences.json".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/.logseq/preferences.json";
  };
}
