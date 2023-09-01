{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.jellyfin = {
    image = "linuxserver/jellyfin:latest";
    autoStart = true;

    dependsOn = [];

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
    };

    extraOptions = [
      # "--restart=always" # Conflicts with NixOS' default of using --rm
      "--runtime=nvidia"
    ];
  };
}
