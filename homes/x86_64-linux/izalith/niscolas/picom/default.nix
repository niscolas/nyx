{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.niscolas.picom;
  configPathSuffix = "picom/picom.conf";
in {
  options.nyx.niscolas.picom = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."${configPathSuffix}".source =
      if !cfg.enableDebugMode
      then ./picom.conf
      else config.lib.file.mkOutOfStoreSymlink "${config.nyx.niscolas.realPath}/${configPathSuffix}";

    systemd.user.services.picom = {
      Unit = {
        Description = "Picom X11 compositor";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Install = {WantedBy = ["graphical-session.target"];};

      Service = {
        ExecStart = "${lib.getExe pkgs.picom} --config ${config.xdg.configFile."${configPathSuffix}".source}";
      };
    };
  };
}
