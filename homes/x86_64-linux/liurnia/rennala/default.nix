{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    outputs.homeManagerModules.bottom
    outputs.homeManagerModules.ripgrep
    outputs.homeManagerModules.zsh
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };

    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  nyx = {
    bottom.enable = true;
    ripgrep.enable = true;
    zsh.enable = true;
  };

  home = {
    username = "rennala";
    homeDirectory = "/home/rennala";

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  programs = {
    # Let home Manager install and manage itself.
    home-manager.enable = true;
    nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
    };
  };
}
