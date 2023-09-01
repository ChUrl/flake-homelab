{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.wireguard_vps = {
    image = "linuxserver/wireguard:latest";
    autoStart = true;

    dependsOn = [];

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
      # "--restart=always" # Conflicts with NixOS' default of using --rm
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
    ];
  };
}
