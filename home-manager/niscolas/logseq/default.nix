{ config, pkgs, ... }:

let
    unitName = "logseq-backup";
    logseqBackup = pkgs.writeShellApplication {
        name = "${unitName}";
        runtimeInputs = [ pkgs.git pkgs.openssh ];
        text = builtins.readFile( ./${unitName}.sh );
    };
in
{
    systemd.user.services.${unitName} = {
        Install.WantedBy = [ "default.target" ];
        Service = {
            Type = "oneshot";
            ExecStart = "${logseqBackup}/bin/${unitName}";
        };
    };

    systemd.user.timers.${unitName} = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
            Unit = "${unitName}.service";
        };
    };

    home.packages = with pkgs; [ logseq ];

    home.file = {
        ".logseq/config".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/config";

        ".logseq/settings".source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/settings";

        ".logseq/preferences.json".source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/preferences.json";
    };
}
