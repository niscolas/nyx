{
  lib,
  config,
  ...
}: let
  cfg = config.erdtree.niscolas.fish;
in {
  options.erdtree.niscolas.fish = {
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

    erdtree.niscolas.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
