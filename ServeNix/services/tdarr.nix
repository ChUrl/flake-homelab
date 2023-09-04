{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.tdarr = {
    image = "haveagitgat/tdarr:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "8265:8265" # WebUI
      "8266:8266" # Server
    ];

    volumes = [
      "/media/Video:/media/Video"
      "/media/Movie:/media/Movie"
      "/media/Show:/media/Show"
      "tdarr_config:/app/configs"
      "tdarr_server:/app/server"
      "tdarr_cache:/temp"
      "tdarr_logs:/app/logs"
    ];

    environment = {
      TZ = "Europe/Berlin";
      PUID = "3001";
      PGID = "3001";
      UMASK_SET = "755";
      serverIP = "192.168.86.105";
      serverPort = "8266";
      webUIPort = "8265";
      internalNode = "true";
      inContainer = "true";
      nodeName = "InternalNode";
      NVIDIA_DRIVER_CAPABILITIES = "all";
      NVIDIA_VISIBLE_DEVICES = "all";
    };

    extraOptions = [
      # "--gpus device=0" # This only works when I start the container using sudo, but not from the systemd service?
      # "--runtime=nvidia" # Older option but seems to work
      "--gpus=all"
      "--device=/dev/dri:/dev/dri"
      # "--log-opt max-size=10m"
      # "--log-opt max-file=5"
    ];
  };
}
