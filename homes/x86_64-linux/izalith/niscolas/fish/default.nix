{
  lib,
  config,
  ...
}: let
  cfg = config.nyx.niscolas.fish;
in {
  imports = [../starship];

  options.nyx.niscolas.fish = {
    enable = lib.mkEnableOption {};
    enableStarship = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nyx.niscolas.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    programs = {
      eza = {
        enable = true;
        enableAliases = true;
        git = true;
        icons = true;
      };

      fish = {
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

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
