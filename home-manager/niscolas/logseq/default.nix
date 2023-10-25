{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
     logseq 
  ];

  home.file.".logseq/config".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/config";

  home.file.".logseq/settings".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/settings";

  home.file.".logseq/preferences.json".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/bonfire/nyx/home-manager/niscolas/logseq/.logseq/preferences.json";
}
