{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.homepage = {
    image = "ghcr.io/benphelps/homepage:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "3000:3000"
    ];

    volumes = [
      "homepage_config:/app/config"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {};

    extraOptions = [];
  };
}
