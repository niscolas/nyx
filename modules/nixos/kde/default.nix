{
  config,
  lib,
  outputs,
  pkgs,
  username,
  ...
}: let
  cfg = config.nyx.kde;

  # https://github.com/turtton/dotnix/blob/a40b27232011435a0b8e60baa8d0af169f97e3f0/os/wm/plasma5.nix#L33
  # References: https://github.com/brianIcke/nixos-conf/blob/226c97d1b78a527eb0126a7012e27d935d4b4da0/system/BrianTUX/pkgs/wallpaper-engine-plasma-plugin.nix#L37
  glslang-submodule = with pkgs;
    stdenv.mkDerivation {
      name = "glslang";
      installPhase = ''
        mkdir -p $out
      '';
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "glslang";
        rev = "c34bb3b6c55f6ab084124ad964be95a699700d34";
        sha256 = "IMROcny+b5CpmzEfvKBYDB0QYYvqC5bq3n1S4EQ6sXc=";
      };
    };
  wallpaper-engine-kde-plugin = with pkgs;
    stdenv.mkDerivation rec {
      pname = "wallpaperEngineKde";
      version = "91d8e25c0c94b4919f3d110c1f22727932240b3c";
      src = fetchFromGitHub {
        owner = "Jelgnum";
        repo = "wallpaper-engine-kde-plugin";
        rev = version;
        hash = "sha256-ff3U/TXr9umQeVHiqfEy38Wau5rJuMeJ3G/CZ9VE++g=";
        fetchSubmodules = true;
      };
      nativeBuildInputs = [
        cmake
        extra-cmake-modules
        glslang-submodule
        pkg-config
        gst_all_1.gst-libav
        shaderc
      ];
      buildInputs =
        [
          mpv
          lz4
          vulkan-headers
          vulkan-tools
          vulkan-loader
        ]
        ++ (with libsForQt5; with qt5; [plasma-framework qtwebsockets qtwebchannel qtx11extras qtdeclarative])
        ++ [(python3.withPackages (python-pkgs: [python-pkgs.websockets]))];
      cmakeFlags = ["-DUSE_PLASMAPKG=OFF"];
      dontWrapQtApps = true;
      postPatch = ''
        rm -rf src/backend_scene/third_party/glslang
        ln -s ${glslang-submodule.src} src/backend_scene/third_party/glslang
      '';
      #Optional informations
      meta = with lib; {
        description = "Wallpaper Engine KDE plasma plugin";
        homepage = "https://github.com/Jelgnum/wallpaper-engine-kde-plugin";
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
    };
in {
  options.nyx.kde = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        latte-dock
        wallpaper-engine-kde-plugin
        (python3.withPackages (python-pkgs: [python-pkgs.websockets]))
      ]
      ++ (with qt5; [
        qtwebsockets
      ])
      ++ (with libsForQt5; [
        bismuth
      ]);

    services.xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        # defaultSession = "plasmax11";
      };

      # desktopManager.plasma6.enable = true;
      desktopManager.plasma5.enable = true;
    };

    system.activationScripts = {
      wallpaper-engine-kde-plugin.text = ''
        wallpaperenginetarget=share/plasma/wallpapers/com.github.casout.wallpaperEngineKde
        link_path=/home/${username}/.local/$wallpaperenginetarget

        if [ ! -L $link_path ]; then
            ln -s ${wallpaper-engine-kde-plugin}/$wallpaperenginetarget $link_path
        fi
      '';
    };
  };
}