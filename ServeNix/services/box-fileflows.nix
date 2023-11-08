{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.box-fileflows = {
    image = "revenz/fileflows:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "5000:5000"
    ];

    volumes = [
      "/media/Stash-Video:/media/Video"

      "box-fileflows_temp:/temp"
      "box-fileflows_logs:/app/Logs"
      "box-fileflows_config:/app/Data"

      "/var/run/docker.sock:/var/run/docker.sock:ro"
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
