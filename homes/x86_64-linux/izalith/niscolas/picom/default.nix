{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.picom;
  configPathSuffix = "picom/picom.conf";
in {
  options.erdtree.niscolas.picom = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."${configPathSuffix}".source =
      if !cfg.enableDebugMode
      then ./picom.conf
      else config.lib.file.mkOutOfStoreSymlink "${config.erdtree.niscolas.realPath}/${configPathSuffix}";

    systemd.user.services.picom = {
      Unit = {
        Description = "Picom X11 compositor";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Install = {WantedBy = ["graphical-session.target"];};

      Service = {
        ExecStart = "${lib.getExe pkgs.picom} --config ${config.xdg.configFile."${configPathSuffix}".source}";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
