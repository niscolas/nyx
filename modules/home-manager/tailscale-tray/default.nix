{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.tailscale-tray;
  serviceExecStart = pkgs.writeShellScriptBin "tailscale-systray-start" ''
    ${pkgs.tailscale-systray}/bin/tailscale-systray
  '';
in {
  options.nyx.tailscale-tray = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.tailscale-tray = {
      Unit = {
        Description = "Tailscale Tray";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      Install = {WantedBy = ["graphical-session.target"];};
      Service.ExecStart = "${serviceExecStart}/bin/tailscale-systray-start";
    };
  };
}
