{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;

    # TODO: move "AddKeysToAgent" to option when it's oficially released:
    # https://github.com/nix-community/home-manager/commit/7a69b3e738a587915a374994e05e8e10f1216721
    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = let
      liurniaRootConfig = {
        host = "liurnia";
        user = "root";
        identityFile = "~/.ssh/liurnia";
      };
    in {
      nokron = {
        host = "nokron";
        hostname = "139.144.170.177";
        user = "niscolas";
      };

      liurnia = {
        host = "liurnia";
        hostname = "192.168.100.12";
        user = "niscolas";
        identityFile = "~/.ssh/liurnia";
      };

      liurnia_root = liurniaRootConfig // {hostname = "192.168.100.12";};
      liurnia_root_tailscale = liurniaRootConfig // {hostname = "100.83.253.49";};

      github = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/niscolas_github";
      };
    };
  };

  # home.file.".ssh/config".source = ./config;
}
