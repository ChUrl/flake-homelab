{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.gitea-db = {
    image = "postgres:14";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [
      "gitea-db_data:/var/lib/postgresql/data"
    ];

    environment = {
      POSTGRES_USER = "gitea";
      POSTGRES_PASSWORD = "gitea";
      POSTGRES_DB = "gitea";
    };

    extraOptions = [
      "--network=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.gitea = {
    image = "gitea/gitea:latest";
    autoStart = true;

    dependsOn = [
      "gitea-db"
    ];

    ports = [
      "3000:3000"
      # "222:22"
    ];

    volumes = [
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"

      "gitea_data:/data"
    ];

    environment = {
      USER = "christoph";
      USER_UID = "1000";
      USER_GID = "100";

      GITEA__database__DB_TYPE = "postgres";
      GITEA__database__HOST = "gitea-db:5432";
      GITEA__database__NAME = "gitea";
      GITEA__database__USER = "gitea";
      GITEA__database__PASSWD = "gitea";
      
    };

    extraOptions = [
      "--network=behind-nginx"
    ];
  };
}