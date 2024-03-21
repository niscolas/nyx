{config, ...}: {
  services = {
    adguardhome = {
      enable = true;
      settings = {
        bind_port = 805;
        dns = {
          bind_hosts = ["100.83.253.49"];
          port = 53;
        };
      };
    };

    nginx.virtualHosts."adguard.example.com" = {
      locations."/".proxyPass = "http://localhost:${toString (config.services.adguardhome.settings.bind_port)}";
    };
  };
}
