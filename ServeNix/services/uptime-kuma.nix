{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.uptime-kuma = {
    image = "louislam/uptime-kuma:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [
      "uptime-kuma_config:/app/data"

      "/var/run/docker.sock:/var/run/docker.sock"
    ];

    environment = {
      # PUID = "1000";
      # PGID = "1000";
      # TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--net=behind-nginx"
    ];
  };
}
