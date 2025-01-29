{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.whats-up-docker = {
    image = "fmartinou/whats-up-docker:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "3001:3000"
    ];

    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
