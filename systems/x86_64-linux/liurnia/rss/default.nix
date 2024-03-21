{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.liurnia.rss;
in {
  imports = [
    ./fivefilters.nix
    ./freshrss.nix
  ];

  options.nyx.liurnia.rss = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nyx.liurnia = {
      fivefilters.enable = true;
      freshrss.enable = true;
    };
  };
}
