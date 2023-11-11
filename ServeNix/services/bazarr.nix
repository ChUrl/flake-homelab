{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.bazarr = {
    image = "linuxserver/bazarr:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "6767:6767"
    ];

    volumes = [
      "bazarr_config:/config"
      "/media/Show:/tv"
      "/media/Movie:/movies"
    ];

    environment = {
      PUID = "3000";
      PGID = "3000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
