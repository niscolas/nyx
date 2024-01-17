{
  config,
  lib,
  ...
}: let
  cfg = config.erdtree.binary-cache;
in {
  options.erdtree.binary-cache = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = [
          "https://cache.nixos.org/"
          # Devenv cachix - doing some testing
          "https://devenv.cachix.org"
          # Nix community's cache server
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };
}
