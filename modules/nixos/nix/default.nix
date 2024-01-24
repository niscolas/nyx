{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.nix;
in {
  options.erdtree.nix = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment = {
      localBinInPath = true;

      sessionVariables = rec {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_DATA_DIRS = lib.mkDefault "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";

        XDG_BIN_HOME = "$HOME/.bin";
        PATH = [
          "${XDG_BIN_HOME}"
        ];
      };
    };

    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      nixPath = ["/etc/nix/path"];
      registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

      settings = {
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
      };
    };
  };
}
