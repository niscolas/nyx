{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  cfg = config.nyx.nvim;
in {
  imports = [
    outputs.homeManagerModules.ripgrep
  ];

  options.nyx.nvim = {
    enable = lib.mkEnableOption {};
    csharpLs.enable = lib.mkEnableOption {};
    dotnet.enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };

      packages = with pkgs;
        [
          neovim

          # spell checking
          nodePackages.cspell

          # bash
          nodePackages.bash-language-server
          shellcheck

          # lsps
          marksman
          vscode-langservers-extracted
          yaml-language-server

          # lua
          lua-language-server
          stylua

          # misc
          fd
          fzf
          gnumake

          # nix
          alejandra
          deadnix
          nil

          # treesitter
          gcc

          nodejs # markdown-preview.nvim

          # clang-tools
        ]
        ++ (
          if cfg.csharpLs.enable
          then [csharp-ls]
          else []
        )
        ++ (
          if cfg.dotnet.enable
          then [dotnet-sdk_8]
          else []
        );
    };

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.nyx.modulesData.realPath}/nvim/config";

    nyx.ripgrep.enable = true;
  };
}
