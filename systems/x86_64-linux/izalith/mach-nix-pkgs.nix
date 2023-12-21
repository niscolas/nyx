{
  pkgs,
  inputs,
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
in {
  environment.systemPackages = [
    mach-nix-pkgs.${pkgs.system}
  ];
}
