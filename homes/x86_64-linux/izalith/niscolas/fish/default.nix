{
  lib,
  config,
  ...
}: let
  cfg = config.erdtree.fish;
in {
  options.erdtree.fish = {
    enable = lib.mkEnableOption {};
    enableStarship = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';

      plugins = [];

      shellAliases = {
        g = "git";
        n = "nvim";
      };
    };

    programs.starship = {
      enableFishIntegration = cfg.enableStarship;
    };
  };
}