{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.prowlarr = {
    image = "linuxserver/prowlarr:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "9696:9696"
    ];

    volumes = [
      "prowlarr_config:/config"
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
