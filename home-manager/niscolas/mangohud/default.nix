{ config, pkgs, lib, ... }:

{
  programs.mangohud.enable = true;
  home.file.".config/MangoHud/MangoHud.conf".source = ./default.conf;
}
