{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.nvim;
in {
  options.erdtree.nvim = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
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

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.erdtree.modulesData.realPath}/nvim/config";
  };
}
