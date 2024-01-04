{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.stalonetray;
  restartBin = pkgs.writeShellScriptBin "my-stalonetray" ''
    pkill stalonetray
    sleep 1
    stalonetray
  '';
in {
  options.erdtree.niscolas.stalonetray = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [restartBin];

    services.stalonetray = {
      enable = true;
      # https://github.com/kolbusa/stalonetray/blob/master/stalonetrayrc.sample.in
      config = {
        background = "#32302F";
        geometry = "1x1-42+14";
        grow_gravity = "E";
        icon_size = "24";
        kludges = "fix_window_pos,force_icons_size";
        slot_size = "32x32";
        window_layer = "bottom";
      };
    };
  };
}
