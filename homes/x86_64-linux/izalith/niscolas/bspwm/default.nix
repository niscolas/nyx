{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.bspwm;
  configPath = "${config.erdtree.home.configPath}/bspwm";
in {
  options.erdtree.niscolas.bspwm = {
    enable = lib.mkEnableOption {};
    debugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.bspwm = {
      enable = !cfg.debugMode;
      extraConfig = builtins.readFile ./bspwmrc;
    };

    xdg.configFile = {
      "bspwm/bspwmrc".source =
        lib.mkIf cfg.debugMode
        (lib.file.mkOutOfStoreSymlink "${configPath}/bspwmrc");

      "sxhkd/sxhkdrc".source =
        if !cfg.debugMode
        then ./sxhkdrc
        else lib.file.mkOutOfStoreSymlink "${configPath}/sxhkdrc";
    };

    home.packages = lib.mkIf cfg.debugMode (with pkgs; [bspwm]);

    # else {
    #
    #
    #   xdg.configFile = {
    #
    #     "sxhkd/sxhkdrc".source =
    #       ;
    #   };
    # }
  };
}
