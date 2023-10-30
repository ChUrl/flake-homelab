{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.jellystat-db = {
    image = "postgres:15.2";
    autoStart = true;

    dependsOn = [
      # "pihole"

    ];

    ports = [
      # "5432:5432"
    ];

    volumes = [
      "jellystat-db_data:/var/lib/postgresql/data"
    ];

    environment = {
      POSTGRES_DB = "jfstat";
      POSTGRES_USER = "postgres";
      POSTGRES_PASSWORD = "jellystat-db";

      # PUID = "1000";
      # PGID = "1000";
      # TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.jellystat = {
    image = "cyfershepard/jellystat";
    autoStart = true;

    dependsOn = [
      # "pihole"
      "jellystat-db"
    ];

    ports = [
      # "3000:3000"
    ];

    volumes = [
      "jellystat_data:/app/backend/backup-data"
    ];

    environment = {
      POSTGRES_USER = "postgres";
      POSTGRES_PASSWORD = "jellystat-db";
      POSTGRES_IP = "jellystat-db";
      POSTGRES_PORT = "5432";
      JWM_SECRET = "MyUnsecretJwtKey";

      # PUID = "1000";
      # PGID = "1000";
      # TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };
}
