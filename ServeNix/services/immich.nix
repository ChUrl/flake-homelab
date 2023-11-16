{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.immich-server = {
    image = "ghcr.io/immich-app/immich-server:release";
    autoStart = true;

    dependsOn = [
      "immich-redis"
      "immich-database"
      "immich-typesense"
    ];

    ports = [];

    volumes = [
      "immich-server_data:/usr/src/app/upload"

      "/etc/localtime:/etc/localtime:ro"
    ];

    environment = {};

    # command: [ "start.sh", "immich" ]
    entrypoint = "start.sh";
    cmd = [ "immich" ];

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-microservices = {
    image = "ghcr.io/immich-app/immich-server:release";
    autoStart = true;

    # extends:
    #   file: hwaccel.yml
    #   service: hwaccel

    dependsOn = [
      "immich-redis"
      "immich-database"
      "immich-typesense"
    ];

    ports = [];

    volumes = [
      "immich-server_data:/usr/src/app/upload"

      "/etc/localtime:/etc/localtime:ro"
    ];

    environment = {};

    # command: [ "start.sh", "microservices" ]
    entrypoint = "start.sh";
    cmd = [ "microservices" ];

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-machine-learning = {
    image = "ghcr.io/immich-app/immich-machine-learning:release";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [
      "model-cache:/cache"
    ];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-web = {
    image = "ghcr.io/immich-app/immich-web:release";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-typesense = {
    image = "typesense/typesense:0.24.1@sha256:9bcff2b829f12074426ca044b56160ca9d777a0c488303469143dd9f8259d4dd";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [
      "immich-typesense_data:/data"
    ];

    environment = {
      TYPESENSE_API_KEY = "public-fucking-random-api-key";
      TYPESENSE_DATA_DIR = "/data";

      # Remove this to get debug messages
      GLOG_minloglevel = "1";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-redis = {
    image = "redis:6.2-alpine@sha256:3995fe6ea6a619313e31046bd3c8643f9e70f8f2b294ff82659d409b47d06abb";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-database = {
    image = "postgres:14-alpine@sha256:874f566dd512d79cf74f59754833e869ae76ece96716d153b0fa3e64aec88d92";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [
      "immich-database_data:/var/lib/postgresql/data"
    ];

    environment = {
      POSTGRES_PASSWORD = "immich";
      POSTGRES_USER = "immich";
      POSTGRES_DB = "immich";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };

  virtualisation.oci-containers.containers.immich-proxy = {
    image = "ghcr.io/immich-app/immich-proxy:release";
    autoStart = true;

    dependsOn = [
      "immich-server"
      "immich-web"
    ];

    ports = [
      "2283:8080"
    ];

    volumes = [];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
