{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages {pkgs = final;};

  modifications = final: prev: {
    logseq = prev.logseq.overrideAttrs (oldAttrs: let
      newVersion = "0.10.0";
    in {
      version = "${newVersion}";

      src = final.pkgs.fetchurl {
        url = "https://github.com/logseq/logseq/releases/download/${newVersion}/logseq-linux-x64-${newVersion}.AppImage";
        hash = "sha256-igZM+kNe1GDPYckXU6fOjyovHe9gwyBWr7Mc3BxAzOA=";
        name = "${oldAttrs.pname}-${newVersion}.AppImage";
      };
    });

    mangohud = final.callPackage ./mangohud {
      libXNVCtrl = final.pkgs.linuxPackages.nvidia_x11.settings.libXNVCtrl;
      mangohud32 = final.pkgsi686Linux.mangohud;
      inherit (final.python3Packages) mako;
    };

    picom = prev.picom.overrideAttrs (oldAttrs: rec {
      pname = "compfy";
      version = "1.7.2";
      buildInputs =
        [
          final.pcre2
        ]
        ++ oldAttrs.buildInputs;
      src = final.fetchFromGitHub {
        owner = "allusive-dev";
        repo = "compfy";
        rev = version;
        hash = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
      };
      postInstall = '''';
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
