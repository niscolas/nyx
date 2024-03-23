{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.tailscale;
  serviceExecStart = pkgs.writeShellScriptBin "tailscale-systray-start" ''
    ${pkgs.tailscale-systray}/bin/tailscale-systray
  '';
in {
  options.nyx.tailscale = with lib; {
    enable = mkEnableOption {};
    enableTray = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;

    # systemd.user.services.tailscale-tray = lib.mkIf cfg.enableTray {
    #   script = "${serviceExecStart}/bin/tailscale-systray-start";
    #   after = ["graphical-session-pre.target" "tray.target"];
    #   requires = ["tray.target"];
    #   partOf = ["graphical-session.target"];
    #   wantedBy = ["graphical-session.target"];
    # };
  };
}
