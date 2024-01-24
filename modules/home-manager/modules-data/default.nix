{lib, ...}: {
  options.nyx.modulesData = {
    realPath = lib.mkOption {
      type = lib.types.str;
    };
  };
}
