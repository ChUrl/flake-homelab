{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.fileflows = {
    image = "revenz/fileflows:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "5000:5000"
    ];

    volumes = [
      "/media/Video:/media/Video"
      "/media/Movie:/media/Movie"
      "/media/Show:/media/Show"

      "fileflows_temp:/temp"
      "fileflows_logs:/app/Logs"
      "fileflows_config:/app/Data"

      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {
      TZ = "Europe/Berlin";
      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      "--privileged" # Might help with CUDA issues?
      "--gpus=all"
      "--net=behind-nginx"
    ];
  };
}
