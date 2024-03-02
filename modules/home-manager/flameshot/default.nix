{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.flameshot;
  serviceExecStart = pkgs.writeShellScriptBin "flameshot-start" ''
    ${pkgs.flameshot}/bin/flameshot
  '';
in {
  options.nyx.flameshot = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [flameshot];

    systemd.user.services.flameshot = {
      Unit = {
        Description = "Flameshot";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      Install = {WantedBy = ["graphical-session.target"];};
      Service.ExecStart = "${serviceExecStart}/bin/flameshot-start";
    };
  };
}
