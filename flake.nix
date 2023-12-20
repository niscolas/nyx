{
  description = "niscolas flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur.url = github:nix-community/NUR;

    audio-relay.url = "path:./flakes/audio-relay";
    mach-nix.url = "mach-nix/3.5.0";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nv-patch = {
      url = "github:niscolas/nvidia-patch-nixos-fork";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./packages nixpkgs.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations.izalith = nixpkgs.lib.nixosSystem {
      modules = [
        ./machines/izalith/configuration.nix
      ];
      specialArgs = {inherit inputs outputs;};
    };

    homeConfigurations."niscolas@izalith" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./home-manager/niscolas/default.nix
      ];
    };
  };
}
