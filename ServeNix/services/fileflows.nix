{config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.fileflows = {
    image = "revenz/fileflows:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "5000:5000"
    ];

    volumes = [
      "/media/Video:/media/Video"
      "/media/Movie:/media/Movie"
      "/media/Show:/media/Show"
      "fileflows_temp:/temp"
      "fileflows_config:/app/Data"
      "fileflows_logs:/app/Logs"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      # "--restart=always" # Conflicts with NixOS' default of using --rm
    ];
  };
}
