{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.NAME = {
    image = "";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };
}
