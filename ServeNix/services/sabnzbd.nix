{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.sabnzbd = {
    image = "linuxserver/sabnzbd:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "8080:8080"
    ];

    volumes = [
      "/media/Usenet:/downloads"
      "sabnzbd_config:/config"
    ];

    environment = {
      PUID = "3001";
      PGID = "3001";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      # "--restart=always" # Conflicts with NixOS' default of using --rm
    ];
  };
}
