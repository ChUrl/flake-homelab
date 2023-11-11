{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.airsignal = {
    image = "gitea.vps.chriphost.de/christoph/airsignal:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "12776:12776"
      "12776:12776/udp"
    ];

    volumes = [];

    environment = {};

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
