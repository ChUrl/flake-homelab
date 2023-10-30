{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.speedtest-tracker = {
    image = "ghcr.io/alexjustesen/speedtest-tracker:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
      "speedtest-tracker-mariadb"
    ];

    ports = [];

    volumes = [
      "speedtest-tracker_config:/config"
      "speedtest-tracker_web:/etc/ssl/web"

      "/etc/localtime:/etc/localtime:ro"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";

      DB_CONNECTION = "mysql";
      DB_HOST = "speedtest-tracker-mariadb";
      DB_PORT = "3306";
      DB_DATABASE = "speedtest_tracker";
      DB_USERNAME = "speedy";
      DB_PASSWORD = "password";
      
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.speedtest-tracker-mariadb = {
    image = "mariadb:10";
    autoStart = true;
    
    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [
      "speetest-tracker-mariadb_storage:/var/lib/mysql"
    ];

    environment = {
      MARIADB_DATABASE = "speedtest_tracker";
      MARIADB_USER = "speedy";
      MARIADB_PASSWORD = "password";
      MARIADB_RANDOM_ROOT_PASSWORD = "true";
      
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };
}
