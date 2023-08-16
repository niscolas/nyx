{ config, lib, pkgs, ... }:

{
    programs.ssh.enable = true;
    home.file.".ssh/config".source = ./config;
}
