{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.pyload-ng = {
    image = "lscr.io/linuxserver/pyload-ng";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "8000:8000"
      # "9666:9666" # Optional click'n'load
    ];

    volumes = [
      "pyload-ng_config:/config"
      "/media/Usenet/pyloadng:/downloads"
    ];

    environment = {
      PUID = "3001";
      PGID = "3001";
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
