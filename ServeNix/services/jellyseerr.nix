{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.jellyseerr = {
    image = "fallenbagel/jellyseerr:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "5055:5055"
    ];

    volumes = [
      "jellyseerr_config:/app/config"
    ];

    environment = {
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
