{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.wireguard = {
    image = "linuxserver/wireguard:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      "51820:51820"
    ];

    volumes = [
      "wireguard_vps_config:/config"
      "wireguard_vps_modules:/lib/modules"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      # "--net=behind-nginx"
    ];
  };
}
