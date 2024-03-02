{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.emote;
  serviceExecStart = pkgs.writeShellScriptBin "emote-start" ''
    ${pkgs.emote}/bin/emote
  '';
in {
  options.nyx.emote = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [emote];

    systemd.user.services.emote-service = {
      Unit = {
        Description = "Emote";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Install = {WantedBy = ["graphical-session.target"];};
      Service.ExecStart = "${serviceExecStart}/bin/emote-start";
    };
  };
}
