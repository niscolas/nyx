{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    eww
  ];

  home.file.".config/eww".source = ./config;
  home.file.".local/bin/eww_bar.nu".source = ./config/bar/launch.nu;
}
