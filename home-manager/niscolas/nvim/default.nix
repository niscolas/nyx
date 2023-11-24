{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
      clang-tools
      csharp-ls
      dotnet-sdk_8
      fd
      fzf
      gnumake
      lua-language-server
      neovim
      nil
      nodePackages.bash-language-server
      ripgrep
      stylua
      vscode-langservers-extracted
      yaml-language-server
  ];

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/nvim/config";
}
