{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gamemode
  ];

  home.file.".config/gamemode.ini".source = ./gamemode.ini;
}
