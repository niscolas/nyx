{
    description = "niscolas flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mach-nix = {
            url = "mach-nix/3.5.0";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, mach-nix, ... }: {
        nixosConfigurations = {
            izalith = nixpkgs.lib.nixosSystem {
                modules = [
                    ./machines/izalith/configuration.nix
                ];
                specialArgs = { inherit inputs; };
                system = "x86_64-linux";
            };
        };
    };
}
