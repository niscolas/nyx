self: super: {
  mangohud = self.callPackage ../../packages/mangohud {
    libXNVCtrl = self.pkgs.linuxPackages.nvidia_x11.settings.libXNVCtrl;
    mangohud32 = self.pkgsi686Linux.mangohud;
    inherit (self.python3Packages) mako;
  };
}
