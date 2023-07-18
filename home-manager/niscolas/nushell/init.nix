{ config, pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  home.file.".config/nushell/scripts".source = ./scripts;
}
