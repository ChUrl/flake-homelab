{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.wings = {
    image = "ghcr.io/pterodactyl/wings:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "8080:8080"
      "2022:2022"
      "443:443"
    ];

    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/var/lib/docker/containers/:/var/lib/docker/containers/"
      "/etc/ssl/certs:/etc/ssl/certs:ro"

      "wings_etc:/etc/pterodactyl/"
      "wings_var:/var/lib/pterodactyl/"
      "wings_logs:/var/log/pterodactyl/"
      "wings_tmp:/tmp/pterodactyl/"
      "wings_certs:/etc/letsencrypt/"
    ];

    environment = {
      TZ = "Europe/Berlin";
      WINGS_UID = "988";
      WINGS_GID = "988";
      WINGS_USERNAME = "pterodactyl";
    };

    extraOptions = [
      "--network=wings"
    ];
  };
}
