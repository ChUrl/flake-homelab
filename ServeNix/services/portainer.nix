{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.portainer = {
    image = "portainer/portainer-ce:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "8000:8000"
      "9443:9443"
    ];

    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "portainer_config:/data"
    ];

    environment = {};

    extraOptions = [];
  };
}
