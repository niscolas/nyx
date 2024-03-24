{
  config,
  inputs,
  lib,
  modulesPath,
  outputs,
  pkgs,
  ...
}:
with lib; {
  imports = [
    # ./adguard
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./duckdns
    ./hardware-configuration.nix
    ./homepage
    ./media-server
    ./netdata
    ./nextcloud
    ./performance
    ./rss
    inputs.sops.nixosModules.sops
    outputs.nixosModules.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

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
    liurnia = {
      duckdns.enable = true;
      homepage = let
        freshrss = {
          apiPwdKeyword = "_freshrssapipwd_";
          apiPwdFile = config.sops.secrets."freshrss/api_pwd".path;
        };

        nextcloud = {
          ncTokenKeyword = "_nextcloudnctoken_";
          ncTokenFile = config.sops.secrets."nextcloud/nc_token".path;
        };
      in {
        enable = true;
        secrets = {
          "${freshrss.apiPwdKeyword}" = "${freshrss.apiPwdFile}";
          "${nextcloud.ncTokenKeyword}" = "${nextcloud.ncTokenFile}";
        };
        layout = {
          settings = {
            statusStyle = "dot";
          };
          widgets = [
            {
              resources = {
                cpu = true;
                memory = true;
                disk = "/";
              };
            }
            {
              search = {
                provider = "duckduckgo";
                target = "_blank";
              };
            }
          ];
          services = [
            {
              Monitoring = [
                {
                  NETDATA = {
                    icon = "netdata.svg";
                    description = "NET DATA";
                    href = config.nyx.liurnia.netdata.service.url;
                    siteMonitor = config.nyx.liurnia.netdata.service.url;

                    widget = {
                      type = "netdata";
                      url = config.nyx.liurnia.netdata.service.url;
                    };
                  };
                }
              ];
            }
            {
              Services = [
                {
                  NextCloud = let
                    url = config.nyx.liurnia.nextcloud.url;
                  in {
                    icon = "nextcloud.svg";
                    description = "After Cloud...";
                    href = url;
                    siteMonitor = url;
                    widget = {
                      type = "nextcloud";
                      url = url;
                      key = nextcloud.ncTokenKeyword;
                      fields = ["freespace" "activeusers" "numfiles" "numshares"];
                    };
                  };
                }
              ];
            }
            {
              RSS = [
                {
                  FreshRSS = {
                    icon = "freshrss.svg";
                    description = "RSS, but Fresh.";
                    href = config.nyx.liurnia.freshrss.url;
                    siteMonitor = config.nyx.liurnia.freshrss.url;
                    widget = {
                      type = "freshrss";
                      url = config.nyx.liurnia.freshrss.url;
                      username = config.services.freshrss.defaultUser;
                      password = freshrss.apiPwdKeyword;
                    };
                  };
                }
                {
                  "Five Filters" = {
                    icon = "freshrss.svg";
                    description = "It actually uses 5 entire filters.";
                    href = config.nyx.liurnia.fivefilters.url;
                    siteMonitor = config.nyx.liurnia.fivefilters.url;
                  };
                }
              ];
            }
          ];
          bookmarks = [
            {
              Admin = [
                {
                  Tailscale = [
                    {
                      abbr = "TS";
                      icon = "tailscale-light.png";
                      href = "https://login.tailscale.com/admin/";
                    }
                  ];
                }
              ];
            }
            {
              NixOS = [
                {
                  "Nixos Search" = [
                    {
                      icon = "si-nixos";
                      href = "https://search.nixos.org/packages";
                    }
                  ];
                }
                {
                  "Nixos Wiki" = [
                    {
                      icon = "si-nixos";
                      href = "https://nixos.wiki/";
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      netdata.enable = true;
      nextcloud.enable = true;

      media-server = {
        enable = true;
        jellyfin.enable = true;
        sonarr.enable = true;
      };

      performance.enable = true;
      rss.enable = true;
    };
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
      # allowedTCPPorts = [111 2049 4000 4001 4002 20048];
      # allowedUDPPorts = [111 2049 4000 4001 4002 20048];
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

  environment.systemPackages = with pkgs;
    map lib.lowPrio [
      bottom
      curl
      du-dust
      duf
      gitMinimal
      rar
      speedtest-go
      xz
      zip
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
