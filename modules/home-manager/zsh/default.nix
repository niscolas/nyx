{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: let
  cfg = config.nyx.zsh;
  configDir = "${config.nyx.modulesData.realPath}/zsh";
in {
  imports = [
    outputs.homeManagerModules.batcat
    outputs.homeManagerModules.starship
  ];

  options.nyx.zsh = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nyx = {
      batcat.enable = true;
      starship.enable = true;
    };

    programs = {
      eza = {
        enable = true;
        enableAliases = true;
        git = true;
        icons = true;
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "viins";

        shellAliases = {
          cat = "bat";
          g = "git";
          n = "nvim";
          t = "tmux";
        };
        history.size = 10000;
        history.path = "${config.xdg.dataHome}/zsh/history";
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
