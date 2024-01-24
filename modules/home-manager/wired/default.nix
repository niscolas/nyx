{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.wired;
in {
  imports = [inputs.wired.homeManagerModules.default];

  options.nyx.wired = {
    enable = lib.mkEnableOption {};
    enableDebugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.wired.overlays.default
    ];

    xdg.configFile."wired/wired.ron".source =
      if !cfg.enableDebugMode
      then (import ./config.nix)
      else
        config.lib.file.mkOutOfStoreSymlink
        "${config.nyx.modulesData.realPath}/wired/wired.ron";

    services.wired.enable = true;

    # systemd.user.services.wired = {
    #   Unit = {
    #     Description = "wired";
    #     After = ["graphical-session-pre.target"];
    #     PartOf = ["graphical-session.target"];
    #   };
    #
    #   Service = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.wired}/bin/wired";
    #   };
    #
    #   Install.WantedBy = ["graphical-session.target"];
    # };
  };
}
