{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages {pkgs = final;};

  modifications = final: prev: {
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

    logseq = final.pkgs.unstable.logseq;

    mangohud = final.callPackage ./mangohud {
      libXNVCtrl = final.pkgs.linuxPackages.nvidia_x11.settings.libXNVCtrl;
      mangohud32 = final.pkgsi686Linux.mangohud;
      inherit (final.python3Packages) mako;
    };

    neovim = inputs.neovim-nightly-overlay.defaultPackage.${final.pkgs.system};

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
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
    };
  };
}
