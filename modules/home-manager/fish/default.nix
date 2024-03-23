{
  lib,
  config,
  outputs,
  ...
}: let
  cfg = config.nyx.fish;
in {
  imports = [
    outputs.homeManagerModules.batcat
    outputs.homeManagerModules.starship
  ];

  options.nyx.fish = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nyx = {
      batcat.enable = true;

      starship = {
        enable = true;
        enableFishIntegration = true;
      };
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
          cat = "bat";
          g = "git";
          n = "nvim";
          t = "tmux";
        };
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
