{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.radarr = {
    image = "linuxserver/radarr:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
      # "sabnzbd"
      # "prowlarr"
    ];

    ports = [
      # "7878:7878"
    ];

    volumes = [
      "/media/TV-Usenet:/downloads"
      "/media/Movie:/movies"

      "radarr_config:/config"
    ];

    environment = {
      PUID = "3000";
      PGID = "3000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
