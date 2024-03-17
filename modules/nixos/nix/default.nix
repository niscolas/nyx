{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.nix;
in {
  options.nyx.nix = {
    enable = lib.mkEnableOption {};
    nixPathAndRegistry.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
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

      etc =
        if cfg.nixPathAndRegistry.enable
        then
          lib.mapAttrs'
          (name: value: {
            name = "nix/path/${name}";
            value.source = value.flake;
          })
          config.nix.registry
        else {};
    };

    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      nixPath = lib.mkIf cfg.nixPathAndRegistry.enable ["/etc/nix/path"];
      registry = lib.mkIf cfg.nixPathAndRegistry.enable ((lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs));

      settings = {
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
      };
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add any missing dynamic libraries for unpackaged programs

        # here, NOT in environment.systemPackages
      ];
    };
  };
}
