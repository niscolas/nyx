{
  description = "niscolas flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";

    audio-relay.url = "path:/home/niscolas/bonfire/nyx/packages/audio-relay";
    mach-nix.url = "mach-nix/3.5.0";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
  in {
    nixosConfigurations.izalith = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./machines/izalith/configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };

    homeConfigurations."niscolas@izalith" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        # https://github.com/NixOS/nixpkgs/issues/97855#issuecomment-1741818344
        # config.nix.registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

        overlays = [
          (import ./home-manager/niscolas/overlays.nix)
          neovim-nightly-overlay.overlay
        ];
      };
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./home-manager/niscolas/default.nix
      ];
    };
  };
}
