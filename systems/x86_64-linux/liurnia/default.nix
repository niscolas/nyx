{
  config,
  inputs,
  lib,
  modulesPath,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # ./adguard
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./duckdns
    ./hardware-configuration.nix
    ./nextcloud
    ./rss
    inputs.sops.nixosModules.sops
    outputs.nixosModules.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nyx = {
    nix.enable = true;
    liurnia.duckdns.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/root/.config/sops/age/liurnia_keys.txt";
  };

  networking = {
    hostId = "0e7a5ec4";
    hostName = "liurnia";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      # for NFSv3; view with `rpcinfo -p`
      allowedTCPPorts = [80 111 2049 4000 4001 4002 20048];
      allowedUDPPorts = [80 111 2049 4000 4001 4002 20048];
    };
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

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "niscolas@proton.me";
      group = "nginx";
    };
  };

  users.users.nginx.extraGroups = ["acme"];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtNKiqzYl9BjjO7Frt65b3yObjeAxrBV/8TVUxRj3Jwv6xmDciAz0E0Hpr5vfJpAM8o4inNxNBbNtxIdIBz863TjGLExaaMI6Mtr6lWXknhWeAuTFSn3daYil4NF730UIVR6y1qSsONIivnBgDJmgyGkks8S3PaKPmzYV95aNJBC8qrvi8hYcDmQ4XkEPaVxGXuc0Jm9dPmS+qJ+BE/HHAeYow6sO6QVuLq8R71FcbTEv07a+ebL8UlDsZvVfqMvwIsRicocqrgYWFg70FG3gIvokN8uc7PU7exTonDPI9eQLdNa9SzQvwTSfqv5bhAp+ptW8l8Cyfsqn0Ecf2SiH9nzTzVC1ZIQQlx3k4hTghwrn7KfVfsVtcDZXBsZAx0KsY34XdT78JN2pwwcbvSnEvZhqj3UroF59V4G03vLLOe7OU+reF3kJiXmMYfAycNHAYeUNdtoPeO5EkDmLSf96rZNNGGM/UA0kYk10hWTso0fOvkBe4iMvzdFnUBjXU4LuQlR+qaObkIwPbYH0Kzoyk3yTv4J0DTYcofqgc7Yh/3Mxz8rWLqBkp1H5C84OYWAoZ8vo9yY/9Up2UebvMB9zItq66CG0iu0XkMvbQvDtcVqftNDuU/kc5OiR43OP2gOsF9Dgp5g+janL1d3yao/9NnPlTQXdDWe/jaLDLx9cfdQ== niscolas@izalith"
  ];

  services = {
    nfs.server.enable = true;

    nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
    };

    openssh.enable = true;
    tailscale.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
