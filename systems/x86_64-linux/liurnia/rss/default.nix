{
  config,
  inputs,
  ...
}: let
  freshrss = {
    address = "freshrss.example.com";
    user = "freshrss";
  };
in {
  sops.secrets = {
    freshrss_pwd = {
      owner = "${freshrss.user}";
    };
  };

  services = {
    freshrss = {
      enable = true;

      user = "${freshrss.user}";
      baseUrl = "http://${freshrss.address}";
      defaultUser = "admin";
      passwordFile = config.sops.secrets.freshrss_pwd.path;
      virtualHost = "${freshrss.address}";
    };

    nginx.virtualHosts."${freshrss.address}" = {
      # forceSSL = true;
      # enableACME = true;
    };
  };
}
