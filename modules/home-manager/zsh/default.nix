{
  config,
  lib,
  outputs,
  ...
}: let
  cfg = config.nyx.zsh;
in {
  imports = [
    outputs.homeManagerModules.batcat
    outputs.homeManagerModules.eza
    outputs.homeManagerModules.starship
  ];

  options.nyx.zsh = {
    enable = lib.mkEnableOption {};
  };

  # TODO: remove normal ZSH config files in ./config/
  config = lib.mkIf cfg.enable {
    nyx = {
      batcat.enable = true;
      eza.enable = true;
      starship.enable = true;
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "viins";

        shellAliases = {
          c = "clear";
          cat = "bat";
          g = "git";
          n = "nvim";
          t = "tmux";
        };
        history.size = 10000;
        history.path = "${config.xdg.dataHome}/zsh/history";
      };

      zoxide.enable = true;
    };
  };
}
