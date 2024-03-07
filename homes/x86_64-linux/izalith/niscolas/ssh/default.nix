{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    # addKeysToAgent = "yes";

    matchBlocks = {
      nokron = {
        host = "nokron";
        hostname = "139.144.170.177";
        user = "niscolas";
      };

      liurnia = {
        host = "nokron";
        hostname = "192.168.100.12";
        user = "niscolas";
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
