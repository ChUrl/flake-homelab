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
      "sabnzbd"
      "prowlarr"
    ];

    ports = [
      "7878:7878"
    ];

    volumes = [
      "/media/Usenet:/downloads"
      "/media/Movie:/movies"
      "radarr_config:/config"
    ];

    environment = {
      PUID = "3001";
      PGID = "3001";
      TZ = "Europe/Berlin";
    };

    extraOptions = [];
  };
}
