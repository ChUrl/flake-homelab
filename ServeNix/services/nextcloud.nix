{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.nextcloud-db = {
    image = "postgres:alpine";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "5432:5432"
    ];

    volumes = [
      "nextcloud-db_data:/var/lib/postgresql/data"
    ];

    environment = {
      POSTGRES_PASSWORD = "nextcloud";
      POSTGRES_DB = "nextcloud";
      POSTGRES_USER = "nextcloud";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.nextcloud-memcache = {
    image = "redis:alpine";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "6379:6379"
    ];

    volumes = [
      "nextcloud-memcache_data:/data"
    ];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.nextcloud = {
    image = "nextcloud:apache";
    autoStart = true;

    dependsOn = [
      "nextcloud-db"
      "nextcloud-memcache"
    ];

    ports = [
      "8080:80"
    ];

    volumes = [
      "nextcloud_data:/var/www/html"

      # Paperless media
      # "/media/paperless-consume:/media/paperless-consume"
      # "/media/paperless-export:/media/paperless-export"
      # "/media/paperless-media:/media/paperless-media"
      "/home/christoph/nextcloud:/flow-scripts"

      # "/var/run/docker.sock:/var/run/docker.sock:ro" # For AiO
    ];

    environment = {
      # Don't add PUID/PGID/TZ or sth like that!

      # Allow uploads larger than 1GB
      APACHE_BODY_LIMIT = "0";
      NEXTCLOUD_TRUSTED_DOMAINS = "https://nextcloud.local.chriphost.de https://local.chriphost.de https://nextcloud.vps.chriphost.de https://vps.chriphost.de";

      # Proxy
      APACHE_DISABLE_REWRITE_IP = "1";
      TRUSTED_PROXIES = "192.168.86.25 212.227.233.241 172.19.0.1";
      OVERWRITEPROTOCOL = "https";
      
      # DB
      POSTGRES_HOST = "nextcloud-db";
      POSTGRES_PASSWORD = "nextcloud";
      POSTGRES_DB = "nextcloud";
      POSTGRES_USER = "nextcloud";

      # Memcache + Transactional Locking
      REDIS_HOST = "nextcloud-memcache";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.nextcloud-cronjob = {
    image = "rcdailey/nextcloud-cronjob";
    autoStart = true;

    dependsOn = [
      "nextcloud"
    ];

    ports = [];

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {
      NEXTCLOUD_CONTAINER_NAME = "nextcloud";
      NEXTCLOUD_CRON_MINUTE_INTERVAL = "5";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
