{ config, pkgs, lib, ... }:

{
    programs.tmux = {
        enable = true;
        plugins = [
            pkgs.tmuxPlugins.sensible
        ];
    };
}
