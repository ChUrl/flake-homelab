{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.sonarr = {
    image = "linuxserver/sonarr:latest";
    autoStart = true;

    dependsOn = [
      "sabnzbd"
      "prowlarr"
    ];

    ports = [
      "8989:8989"
    ];

    volumes = [
      "/media/Usenet:/downloads"
      "/media/Show:/tv"
      "sonarr_config:/config"
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
