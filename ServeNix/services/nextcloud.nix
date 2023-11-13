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

      # "/var/run/docker.sock:/var/run/docker.sock:ro" # For AiO
    ];

    environment = {
      # Don't add PUID/PGID/TZ or sth like that!

      # Allow uploads larger than 1GB
      APACHE_BODY_LIMIT = "0";

      # Proxy
      APACHE_DISABLE_REWRITE_IP = "1";
      TRUSTED_DOMAINS = "nextcloud.local.chriphost.de local.chriphost.de nextcloud.vps.chriphost.de vps.chriphost.de";
      TRUSTED_PROXIES = "192.168.86.25 212.227.233.241";
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
}
