{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.box-unmanic = {
    image = "josh5/unmanic:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "8888:8888"
    ];

    volumes = [
      "/media/Stash-Video:/library/Video"
      # "/media/Stash-Picture:/library/Picture"

      "box-unmanic_temp:/tmp/unmanic"
      "box-unmanic_config:/config"

      # "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {
      TZ = "Europe/Berlin";

      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      "--privileged" # Helps with CUDA issues
      "--gpus=all"
      "--net=behind-nginx"
    ];
  };
}
