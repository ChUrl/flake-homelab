{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.gitea-runner = {
    image = "gitea/act_runner:latest";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [
      "gitea-runner_data:/data"
    
      "/var/run/docker.sock:/var/run/docker.sock"
    ];

    environment = {
      GITEA_INSTANCE_URL = "http://gitea:3000";

      # NOTE: This token is invalid, when re-registering is needed it has to be refreshed
      GITEA_RUNNER_REGISTRATION_TOKEN = "tsNZb2R8KrRdcN9imoo5EAF7PVc7gM0uYWd0Huuy";
    };

    extraOptions = [
      "--network=behind-nginx"
    ];
  };
}
