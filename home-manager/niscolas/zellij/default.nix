{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    zellij
  ];

  home.file.".config/zellij".source = ./config;
}
