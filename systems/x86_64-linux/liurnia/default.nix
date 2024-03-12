{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "liurnia";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users = {
    niscolas = {
      isNormalUser = true;
      description = "Nicolas";
      extraGroups = ["networkmanager" "wheel" "sudo"];

      packages = with pkgs; [];

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFnTJQsQZQl5i6Uisxel7m1IBgh1zFuiCMfsIslsB5zMCgqqIhzWoFNhSnASXj9fJ6sTTz6HcDQs3QcJzaL4acOniU+Vc9LKxSveZeZLeIIbfB3Tq3d60Ox7FEvFTonj3te2P/xGgfIWO1Qw3wvJBYP0OiUUEQQbaAttsiurPC1tUzXowsrQJSNHKlh0fMJP86839wWdaO8JqhLaYZpLuPdHwehwWaCmfBejgx8rQVQFn4HgdOXFoaYnRQjom1sPEGdvyb+NpJ77akicT2Q9S47VQVFOLdsR1rxWBJPG1XwXA4JjCMu+mb8gHT/pUKOkPoUtryhC61dApke7H3qXavqQ5JgHeg3N/9HK5p5lju534MzT4r4+s3JCkymzQpfk75POikqRrO1wd4riLuF+JLJ16tvzezOgSE0WM8VqhgMpXhRonk/4nSzORowOdgWycqvT6jC98us3WYORmgSpPH6xlVaVfeVdFOyaIGOkowOT6CauAcbbYf39A1eZ17/VjUenMHGPv+knveO4FcEW+M9NgBbpXDFKgKzWaaXDSCl4+ZVG2Tpn+N532TetWnk+DCx0bVySwdpX1nPA6tyoJtZcD2h0dhQyxki1+f16I6O3ZbjZurnczYoBd6Au6v84SRWt5vJbAN3osZ/w4yqOp4kFjKVeX7D5Bn9OETp6F7Pw== niscolas@izalith"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
