{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.box-stash = {
    image = "stashapp/stash:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "9999:9999"
    ];

    volumes = [
      "/media/Stash-Picture:/data/picture"
      "/media/Stash-Video:/data/video"

      "box-stash_config:/root/.stash"
      "box-stash_metadata:/metadata"
      "box-stash_generated:/generated"
      "box-stash_blobs:/blobs"
      "box-stash_cache:/cache"
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
