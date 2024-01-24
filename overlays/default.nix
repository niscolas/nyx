{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages {pkgs = final;};

  modifications = final: prev: {
    chromium = final.pkgs.unstable.chromium;
    eww = inputs.eww-tray3.packages."${final.pkgs.system}".default;
    heroic = final.pkgs.unstable.heroic;

    input-leap = prev.input-leap.overrideAttrs (
      oldAttrs: let
        version = "unstable-2023-10-24";
      in {
        version = "${version}";

        src = final.pkgs.fetchFromGitHub {
          owner = "input-leap";
          repo = "input-leap";
          rev = "2376b7a660cb6b1a11dee9f1376199aa93863b8c";
          hash = "sha256-/itlejAYcM0ICeiGsdZPy8BBWkZkDQo8vBQihbrtwDg=";
          fetchSubmodules = true;
        };
      }
    );

    kanata = final.pkgs.unstable.kanata;

    linux-wallpaperengine = prev.linux-wallpaperengine.overrideAttrs (oldAttrs: let
      newVersion = "unstable-2023-12-24";
    in {
      version = newVersion;

      src = final.pkgs.fetchFromGitHub {
        owner = "Almamu";
        repo = "linux-wallpaperengine";
        # upstream lacks versioned releases
        rev = "e28780562bdf8bcb2867cca7f79b2ed398130eb9";
        hash = "sha256-VvrYOh/cvWxDx9dghZV5dcOrfMxjVCzIGhVPm9d7P2g=";
      };
    });

    logseq = final.pkgs.unstable.logseq;

    ludusavi = final.pkgs.unstable.ludusavi;

    mangohud = final.callPackage ./mangohud {
      libXNVCtrl = final.pkgs.linuxPackages.nvidia_x11.settings.libXNVCtrl;
      mangohud32 = final.pkgsi686Linux.mangohud;
      inherit (final.python3Packages) mako;
    };

    neovim = final.pkgs.unstable.neovim;
    picom = inputs.ft-labs-picom.defaultPackage.${final.pkgs.system};
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
    };
  };
}
