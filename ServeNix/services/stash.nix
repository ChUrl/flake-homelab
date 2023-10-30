{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.stash = {
    image = "stashapp/stash:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "9999:9999"
    ];

    volumes = [
      "/media/Picture:/data/picture"
      "/media/Video:/data/video"

      "stash_config:/root/.stash"
      "stash_metadata:/metadata"
      "stash_generated:/generated"
      "stash_blobs:/blobs"
      "stash_cache:/cache"
    ];

    environment = {
      STASH_PORT = "9999";
      STASH_CACHE = "/cache/";
      STASH_GENERATED = "/generated/";
      STASH_METADATA = "/metadata/";
      STASH_STASH = "/data/";

      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      "--privileged"
      "--gpus=all"
      "--net=behind-nginx"
    ];
  };
}
