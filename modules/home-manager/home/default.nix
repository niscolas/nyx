{
  config,
  lib,
  ...
}: {
  options.erdtree.home = {
    configPath = lib.mkOption {
      type = lib.types.string;
      default = "${config.home.homeDirectory}";
    };
  };
}
