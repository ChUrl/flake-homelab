{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.metube = {
    image = "ghcr.io/alexta69/metube";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "3366:8081"
    ];

    volumes = [
      "/media/Usenet/metube:/downloads"
    ];

    environment = {
      UID = "3001";
      GID = "3001";

      # NVIDIA_VISIBLE_DEVICES = "all";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      # "--gpus=all"
      "--network=behind-nginx"
    ];
  };
}