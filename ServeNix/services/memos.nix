{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.memos = {
    image = "ghcr.io/usememos/memos:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "5230:5230"
    ];

    volumes = [
      "memos_data:/var/opt/memos"
    ];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
