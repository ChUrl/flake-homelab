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
      "kopia_temp:/tmp"

      # Repository, where snapshots are stored (incrementally)
      "/media/synology-syncthing:/repository"

      # Folders that are backed up
      # "adguard_config:/data/adguard_config:ro" # ThinkNix
      # "adguard_work:/data/adguard_work:ro" # ThinkNix
      "authelia_config:/data/authelia_config:ro"
      # "bazarr_config:/data/bazarr_config:ro" # Disabled
      # "box-fileflows_config:/data/box-fileflows_config:ro" # Replaced with Unmanic
      # "box-hydra_config:/data/box-hydra_config:ro" # Disabled
      # "box-sabnzbd_config:/data/box-sabnzbd_config:ro" # Disabled
      "box-stash_blobs:/data/box-stash_blobs:ro"
      "box-stash_config:/data/box-stash_config:ro"
      "box-stash_generated:/data/box-stash_generated:ro"
      "box-stash_metadata:/data/box-stash_metadata:ro"
      "box-unmanic_config:/data/box-unmanic_config:ro"
      # "fileflows_config:/data/fileflows_config:ro" # Replaced with Unmanic
      "formula10_cache:/data/formula10_cache:ro"
      "formula10_data:/data/formula10_data:ro"
      "gitea-db_data:/data/gitea-db_data:ro"
      "gitea-runner_config:/data/gitea-runner_config:ro"
      "gitea-runner_data:/data/gitea-runner_data:ro"
      "gitea_data:/data/gitea_data:ro"
      "heidi_config:/data/heidi_config:ro"
      # "homeassistant_config:/data/homeassistant_config:ro" # ThinkNix
      "homepage_config:/data/homepage_config:ro"
      "immich-database_data:/data/immich-database_data:ro"
      "immich_config:/data/immich_config:ro"
      "immich_data:/data/immich_data:ro"
      "immich_machine-learning:/data/immich_machine-learning:ro"
      "jellyfin_config:/data/jellyfin_config:ro"
      # "jellyseerr_config:/data/jellyseerr_config:ro" # Disabled
      # "jellystat-db_data:/data/jellystat-db_data:ro" # Disabled
      # "jellystat_data:/data/jellystat_data:ro" # Disabled
      "nextcloud-db_data:/data/nextcloud-db_data:ro"
      "nextcloud_data:/data/nextcloud_data:ro"
      "nginx_config:/data/nginx_config:ro"
      "nginx_letsencrypt:/data/nginx_letsencrypt:ro"
      "nginx_snippets:/data/nginx_snippets:ro"
      "paperless-postgres_data:/data/paperless-postgres_data:ro"
      "paperless_data:/data/paperless_data:ro"
      "portainer_config:/data/portainer_config:ro"
      # "prowlarr_config:/data/prowlarr_config:ro" # Disabled
      # "radarr_config:/data/radarr_config:ro" # Disabled
      # "sabnzbd_config:/data/sabnzbd_config:ro" # Disabled
      # "sonarr_config:/data/sonarr_config:ro" # Disabled
      # "uptime-kuma_config:/data/uptime-kuma_config:ro" # Disabled
      "wireguard_vps_config:/data/wireguard_vps_config:ro"
    ];

    environment = {
      TZ = "Europe/Berlin";
      USER = "christoph";
      KOPIA_PASSWORD = (builtins.readFile ./kopia.password);
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
      "--privileged"
      "--device=/dev/fuse:/dev/fuse:rwm"
      "--cap-add=SYS_ADMIN"
      "--net=behind-nginx"
    ];
  };
}
