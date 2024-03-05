{
  description = "niscolas flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur.url = "github:nix-community/NUR";

    audio-relay.url = "github:niscolas/audiorelay-flake-fork";
    eww-tray3.url = "github:ralismark/eww/tray-3";
    ft-labs-picom.url = "github:FT-Labs/picom";
    mach-nix.url = "mach-nix/3.5.0";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nbfc.url = "github:nbfc-linux/nbfc-linux";
    nvidia-patch = {
      url = "github:niscolas/nvidia-patch-nixos-fork";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    hosts.url = "github:StevenBlack/hosts";
    wired.url = "github:Toqozz/wired-notify";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    forAllSystems = nixpkgs.lib.genAttrs systems;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages.x86_64-linux = {
      nixos-rebuild = let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
        with pkgs;
          pkgs.writeScriptBin "nixos-rebuild" ''
            ${git}/bin/git diff -U0 *.nix
            echo "NixOS Rebuilding..."
            sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
             cat nixos-switch.log | grep --color error && false)
            gen=$(nixos-rebuild list-generations | grep current)
            ${git}/bin/git commit -am "$gen"
          '';
    };
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
      modules = [./systems/x86_64-linux/izalith];
      specialArgs = {inherit inputs outputs;};
    };

    homeConfigurations = {
      "niscolas@izalith" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./homes/x86_64-linux/izalith/niscolas];
      };

      "work" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./homes/aarch64-darwin/haligtree/main];
      };
    };
  };
}
