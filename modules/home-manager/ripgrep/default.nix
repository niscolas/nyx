{
  config,
  lib,
  ...
}: let
  cfg = config.nyx.ripgrep;
in {
  options.nyx.ripgrep = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;

      arguments = [
        "--colors=line:style:bold"
        "--hidden"
        "--max-columns-preview"
        "--smart-case"
      ];
    };
  };
}
