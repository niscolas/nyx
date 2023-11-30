{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".config/MangoHud/MangoHud.conf".source = ./default.conf;
}
