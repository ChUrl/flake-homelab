{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.NAME = {
    image = "";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [];

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
