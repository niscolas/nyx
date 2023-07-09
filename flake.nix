{
  description = "niscolas flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: rec {
    #legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
      #import inputs.nixpkgs {
      #inherit system;

      # NOTE: Using `nixpkgs.config` in your NixOS config won't work
      # Instead, you should set nixpkgs configs here
      # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
      #config.allowUnfree = true;
    #});

    nixosConfigurations = {
      izalith = nixpkgs.lib.nixosSystem {
        #pkgs = legacyPackages.x86_64-linux;

        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration.nix ];
      };
    };
  };
}
