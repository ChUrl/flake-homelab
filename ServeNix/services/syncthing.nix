{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.syncthing = {
    image = "lscr.io/linuxserver/syncthing:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "8384:8384" # WebUI
      "22000:22000/tcp"
      "22000:22000/udp"
      "21027:21027/udp"
    ];

    volumes = [
      "syncthing_config:/config"

      "gitea_data:/data/gitea:ro"
      "immich_data:/data/immich:ro"
      "nextcloud_data:/data/nextcloud:ro"
      "memos_data:/data/memos:ro"

      # TODO: Add the rest
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--net=behind-nginx"
    ];
  };
}
