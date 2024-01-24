{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.niscolas.kanata;
  configDir = "${config.nyx.niscolas.realPath}/kanata";
  serviceExecStart = pkgs.writeShellScript "kanata-service" ''
    ${pkgs.kanata}/bin/kanata --cfg ${config.home.homeDirectory}/.config/kanata/kanata.kbd | ${pkgs.coreutils}/bin/tee /tmp/kanata-layer.log
  '';
in {
  options.nyx.niscolas.kanata = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kanata
    ];

    home.file.".config/kanata".source =
      if !cfg.enableDebugMode
      then ./config
      else config.lib.file.mkOutOfStoreSymlink "${configDir}/config";

    systemd.user.services.kanata = {
      Install.WantedBy = ["default.target"];
      Service = {
        Environment = "DISPLAY=:0";
        # ExecStartPre = "modprobe uinput";
        ExecStart = "${serviceExecStart}";
        Restart = "no";
        Type = "simple";
      };
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = "https://github.com/jtroo/kanata";
      };
    };
  };
}
