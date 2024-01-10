{lib, ...}: {
  options.erdtree.modulesData = {
    realPath = lib.mkOption {
      type = lib.types.str;
    };
  };
}
