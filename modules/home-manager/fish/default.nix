{
  lib,
  config,
  outputs,
  ...
}: let
  cfg = config.nyx.fish;
in {
  imports = [outputs.homeManagerModules.starship];

  options.nyx.fish = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nyx.starship = {
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
