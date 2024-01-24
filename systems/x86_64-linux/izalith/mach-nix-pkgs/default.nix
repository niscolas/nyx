{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  l = inputs.nixpkgs.lib // builtins;

  supportedSystems = ["x86_64-linux"];

  forAllSystems = f:
    l.genAttrs supportedSystems
    (system: f system (import inputs.nixpkgs {inherit system;}));

  mach-nix-pkgs = forAllSystems (system: pkgs:
    inputs.mach-nix.lib."${system}".mkPython {
      requirements = ''
        ue4cli
      '';
    });

  cfg = config.nyx.izalith.mach-nix-pkgs;
in {
  options.nyx.izalith.mach-nix-pkgs = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      mach-nix-pkgs.${pkgs.system}
    ];
  };
}
