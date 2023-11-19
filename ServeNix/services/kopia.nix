{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.kopia = {
    image = "kopia/kopia:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "51515:51515"
    ];

    volumes = [
      "kopia_config:/app/config"
      "kopia_cache:/app/cache"
      "kopia_logs:/app/logs"
      "kopia_temp:/tmp/shared"

      "/media/synology-syncthing:/repository"

      "nextcloud_data:/data/nextcloud:ro"
      "immich_data:/data/immich:ro"
      "gitea_data:/data/gitea:ro"
      "memos_data:/data/memos:ro"
    ];

    environment = {
      USER = "christoph";
      KOPIA_PASSWORD = "kopia";
    };

    entrypoint = "/bin/kopia";

    cmd = [
      "server"
      "start"
      "--disable-csrf-token-checks"
      "--insecure"
      "--address=0.0.0.0:51515"
      "--server-username=christoph"
      "--server-password=kopia"
    ];

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
