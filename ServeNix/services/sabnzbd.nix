{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.sabnzbd = {
    image = "linuxserver/sabnzbd:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "8080:8080"
    ];

    volumes = [
      "/media/TV-Usenet:/downloads"

      "sabnzbd_config:/config"
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
