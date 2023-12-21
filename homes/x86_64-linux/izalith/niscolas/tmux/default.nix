{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "Space";

    plugins = [
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.gruvbox
    ];
  };
}
