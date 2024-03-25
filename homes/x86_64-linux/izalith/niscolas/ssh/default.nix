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

    matchBlocks = {
      nokron = {
        host = "nokron";
        hostname = "139.144.170.177";
        user = "niscolas";
      };

      liurniaRennala = {
        host = "liurnia";
        hostname = "100.83.253.49";
        identityFile = "~/.ssh/liurnia";
        user = "rennala";
      };

      liurniaRoot = {
        host = "liurnia";
        hostname = "100.83.253.49";
        identityFile = "~/.ssh/liurnia";
        user = "root";
      };

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
