{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
      csharp-ls
      dotnet-sdk_8
      fd
      fzf
      gnumake
      lua-language-server
      neovim
      nil
      ripgrep
      stylua
      vscode-langservers-extracted
      libclang
      nodePackages.bash-language-server
      yaml-language-server
  ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/nvim/config";
}
