{
  config,
  lib,
  ...
}: {
  options.nyx.niscolas.realPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nyx/homes/aarch64-darwin/halightree/main";
  };
}
