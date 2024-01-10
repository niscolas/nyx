{
  config,
  lib,
  ...
}: {
  options.erdtree.niscolas.realPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas";
  };
}
