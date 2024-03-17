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
  };

  # virtualisation.oci-containers.containers = {
  #   freshrss = {
  #     image = "freshrss/freshrss";
  #     ports = ["802:80"];
  #     environment = {
  #       TZ = "America/Sao_Paulo";
  #       CRON_MIN = "1,31";
  #     };
  #     extraOptions = [
  #       "--restart=unless-stopped"
  #       "--log-opt max-size=10m "
  #     ];
  #
  #     volumes = let
  #       baseDir = "/var/lib/freshrss";
  #     in [
  #       "freshrss_data:${baseDir}/data"
  #       "freshrss_extensions:${baseDir}/extensions"
  #     ];
  #   };

  virtualisation.oci-containers.containers.fivefilters-full-text-rss = {
    image = "heussd/fivefilters-full-text-rss:latest";

    environment = {
      # Leave empty to disable admin section
      # FTR_ADMIN_PASSWORD = "";
    };

    volumes = ["rss-cache:/var/lib/fivefilters-cache"];
    ports = ["801:80"];
  };
}
