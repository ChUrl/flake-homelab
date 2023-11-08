{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.box-hydra = {
    image = "linuxserver/nzbhydra2:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
      # "sabnzbd"
    ];

    ports = [
      # "5076:5076"
    ];

    volumes = [
      "box-hydra_config:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
    ];
  };
}
