{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.pterodactyl-db = {
    image = "mariadb:10.5";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [
      "pterodactyl-db_data:/var/lib/mysql"
    ];

    environment = {
      MYSQL_DATABASE = "panel";
      MYSQL_USER = "pterodactyl";
      MYSQL_PASSWORD = "PterodactylDBPW";
      MYSQL_ROOT_PASSWORD = "PterodactylRootPW";
    };

    cmd = [
      "--default-authentication-plugin=mysql_native_password"
    ];

    extraOptions = [
      "--network=pterodactyl"
    ];
  };

  virtualisation.oci-containers.containers.pterodactyl-cache = {
    image = "redis:alpine";
    autoStart = true;

    dependsOn = [];
    ports = [];
    volumes = [];
    environment = {};
    cmd = [];
    extraOptions = [
      "--network=pterodactyl"
    ];
  };

  virtualisation.oci-containers.containers.pterodactyl-panel = {
    image = "ghcr.io/pterodactyl/panel:latest";
    autoStart = true;

    dependsOn = [
      "pterodactyl-db"
      "pterodactyl-cache"
    ];

    ports = [
      "80:80"
      "443:443"
    ];

    volumes = [
      "pterodactyl_var:/app/var"
      "pterdactyl_nginx:/etc/nginx/http.d"
      "pterodactyl_certs:/etc/letsencrypt"
      "pterodactyl_logs:/app/storage/logs"
    ];

    environment = {
      # This URL should be the URL that your reverse proxy routes to the panel server
      APP_URL = "https://games.local.chriphost.de";
      APP_TIMEZONE = "Europe/Berlin";
      APP_SERVICE_AUTHOR = "christoph.urlacher@protonmail.com";
      TRUSTED_PROXIES = "192.168.86.25"; # Set this to your proxy IP
      DB_PASSWORD = "PterodactylDBPW";
      APP_ENV = "production";
      APP_ENVIRONMENT_ONLY = "false";
      CACHE_DRIVER = "redis";
      SESSION_DRIVER = "redis";
      QUEUE_DRIVER = "redis";
      REDIS_HOST = "pterodactyl-cache";
      DB_HOST = "pterodactyl-db";
      DB_PORT = "3306";
    };

    cmd = [];

    extraOptions = [
      "--network=pterodactyl"
    ];
  };
}
