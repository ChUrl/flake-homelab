{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.hydra = {
    image = "linuxserver/nzbhydra2:latest";
    autoStart = true;

    dependsOn = [
      "sabnzbd"
    ];

    ports = [
      "5076:5076"
    ];

    volumes = [
      "hydra_config:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      # "--restart=always" # Conflicts with NixOS' default of using --rm
    ];
  };
}
