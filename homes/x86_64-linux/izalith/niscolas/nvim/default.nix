{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    alejandra
    clang-tools
    csharp-ls
    deadnix
    dotnet-sdk_8
    fd
    fzf
    gnumake
    lua-language-server
    marksman
    neovim
    nil
    nodePackages.bash-language-server
    ripgrep
    shellcheck
    stylua
    vscode-langservers-extracted
    yaml-language-server
  ];

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/homes/x86_64-linux/izalith/niscolas/nvim/config";
}
