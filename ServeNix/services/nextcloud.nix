{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.netflix = {
    image = "linuxserver/nextcloud:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "443:443"
    ];

    volumes = [
      "nextcloud_config:/config"
      "nextcloud_data:/data"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
