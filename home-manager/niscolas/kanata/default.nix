{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    kanata
  ];

  home.file.".config/kanata".source = ./config;
}
