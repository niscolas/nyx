{
  config,
  pkgs,
  ...
}: {
  sops.secrets.nextcloud_pwd = {
    owner = "nextcloud";
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      hostName = "nextcloud.example.com";
      config.adminpassFile = config.sops.secrets.nextcloud_pwd.path;

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
      };
      extraAppsEnable = true;
      configureRedis = true;
    };
  };
}
