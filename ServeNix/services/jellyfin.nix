{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.jellyfin = {
    image = "linuxserver/jellyfin:latest";
    autoStart = true;

    dependsOn = [
      "pihole"
    ];

    ports = [
      "8096:8096"
    ];

    volumes = [
      "/media/Music:/data/music"
      "/media/Show:/data/tvshows"
      "/media/Movie:/data/movies"
      "jellyfin_config:/config"
    ];

    environment = {
      PUID = "3000";
      PGID = "3000";
      TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
    ];
  };
}
