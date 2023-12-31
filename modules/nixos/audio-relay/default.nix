{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.audio-relay;
in {
  options.erdtree.audio-relay = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.audio-relay.packages."x86_64-linux".audio-relay
    ];

    networking.firewall = {
      allowedTCPPorts = [50000 59100 59200 59716];
      allowedUDPPorts = [50000 59100 59200 59716];
    };
  };
}
