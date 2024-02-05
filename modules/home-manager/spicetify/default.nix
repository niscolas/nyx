# mostly taken from https://github.com/the-argus/spicetify-nix
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.spicetify;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  # import the flake's module for your system
  imports = [inputs.spicetify-nix.homeManagerModule];

  options.nyx.spicetify = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    # allow spotify to be installed if you don't have unfree enabled already
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
      ];

    # configure spicetify :)
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.Onepunch;
      colorScheme = "dark";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        adblock
        keyboardShortcut
      ];
    };
  };
}
