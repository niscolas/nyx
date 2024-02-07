{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = [
    # ./git
    ./options.nix
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.batcat
    outputs.homeManagerModules.bottom
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.fish
    # outputs.homeManagerModules.git
    outputs.homeManagerModules.ideavim
    outputs.homeManagerModules.logseq
    outputs.homeManagerModules.modulesData
    outputs.homeManagerModules.neofetch
    outputs.homeManagerModules.nvim
    outputs.homeManagerModules.ripgrep
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.wezterm
    outputs.nixosModules.binary-cache
  ];

  nix = {
    package = pkgs.nix;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  nyx = {
    alacritty = {
      enable = true;
      enableDebugMode = true;
    };

    batcat = {
      enable = true;
      enableDebugMode = true;
    };

    bottom = {
      enable = true;
      enableDebugMode = true;
    };

    binary-cache.enable = true;

    firefox = {
      enable = false;

      tridactyl = {
        enable = true;
        enableDebugMode = true;
      };
    };

    fish.enable = true;
    # git.enable = true;

    ideavim = {
      enable = true;
      enableDebugMode = true;
    };

    logseq = {
      enable = false;
      enableBackup = false;
    };

    modulesData.realPath = "${config.home.homeDirectory}/nyx/modules/home-manager";

    neofetch = {
      enable = true;
      enableDebugMode = true;
    };

    nvim.enable = true;

    ripgrep = {
      enable = true;
      enableDebugMode = true;
    };

    tmux.enable = true;

    wezterm = {
      enable = true;
      enableDebugMode = true;
    };
  };

  programs.fish.interactiveShellInit =
    lib.mkAfter
    ''
      export PATH="$PATH:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin"
    '';

  home = {
    username = "nicolas.catarina";
    homeDirectory = "/Users/nicolas.catarina";

    sessionVariables = {
      MACHINE_SETUP = "work";
      MACHINE_THEME = "gruvbox";
    };

    packages = with pkgs; [
      # barrier
      fd
      flameshot
      fzf
      gh
      # google-chrome
      # input-leap
      mprocs
      nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
      obsidian
      # parsec-bin
      scrcpy
      xz
    ];

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
