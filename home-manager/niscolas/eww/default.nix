{ config, pkgs, lib, ... }:

let
    eww_bar = pkgs.writeShellScriptBin "eww_bar" ''
        #!/usr/bin/env nu

        ${pkgs.eww}/bin/eww -c ~/.config/eww/bar open bar
    '';

    eww_bar_memory_percentage = pkgs.writeShellScriptBin "eww_bar_memory_percentage" ''
        #!/usr/bin/env nu

        ${pkgs.nushell}/bin/nu -c 'free -m | lines | find "Mem:" | split column -c " " | collect { |x| (($x | get 0.column3 | into int) / ($x | get 0.column2 | into int)) * 100 | into int }'
    '';
in {

    home.packages = with pkgs; [
        eww
        eww_bar
        eww_bar_memory_percentage
    ];

    home.file.".config/eww".source = ./config;
}
