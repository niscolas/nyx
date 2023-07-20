{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neovim

    gnumake

    fd
    fzf
    ripgrep

    stylua

    dotnet-sdk_8
    lua-language-server
  ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/nvim/nvim";
}
