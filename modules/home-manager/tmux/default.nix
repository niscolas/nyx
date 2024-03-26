{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.tmux;
in {
  options.nyx.tmux = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      shortcut = "Space";
      terminal = "tmux-256color";

      plugins = [
        pkgs.tmuxPlugins.sensible
        pkgs.tmuxPlugins.vim-tmux-navigator
        pkgs.tmuxPlugins.gruvbox
      ];

      extraConfig =
        /*
        bash
        */
        ''
          # https://github.com/neovim/neovim/issues/21182#issuecomment-1885036257
          # Proper colors
          set-option -sa terminal-features ',alacritty:RGB' # Makes sure that colors in tmux are the same as without tmux

          # Undercurl
          set-option -ga terminal-features ",alacritty:usstyle"
        '';
    };
  };
}
