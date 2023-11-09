{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.gitea-runner = {
    # Question: For gitea/act_runner dind set config.yaml/docker_host to "unix:///var/run/user/1000/docker.sock"?
    image = "gitea/act_runner:latest";
    # image = "vegardit/gitea-act-runner:dind-latest";

    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [];

    volumes = [
      "gitea-runner_data:/data"
      "gitea-runner_config:/config" # Managed by env variables for vegardit image

      # For rootless-dind
      # "gitea-runner_rootless-docker-auth:/home/rootless/.docker"

      # Cache dind pulled images
      # "gitea-runner_overlay2:/var/lib/docker/overlay2"
      # "gitea-runner_image:/var/lib/docker/image"

    
      "/var/run/docker.sock:/var/run/docker.sock" # Disable for dind
    ];

    environment = {
      # NOTE: gitlab.local.chriphost.de doesn't work, because it gets resolved to 192.168.86.25:443, which is nginx
      GITEA_INSTANCE_URL = "http://192.168.86.25:3000";
      GITEA_RUNNER_NAME = "servenix";

      # Can be generated from inside the container using act_runner generate-config > /config/config.yaml
      CONFIG_FILE = "/config/config.yaml";

      # NOTE: This token is invalid, when re-registering is needed it has to be refreshed
      GITEA_RUNNER_REGISTRATION_TOKEN = "2tYcfzALjmIKILPO4jnIdgfGO8RjBGIZCOoP4bYS";

      # These are for the specific vegardit/gitea-act-runner image
      # GITEA_RUNNER_LOG_LEVEL = "debug";
      # GITEA_INSTANCE_INSECURE = "true";
      # GITEA_RUNNER_JOB_CONTAINER_NETWORK = "host"; # "host" for dind, "behind-nginx" otherwise
      # GITEA_RUNNER_JOB_CONTAINER_PRIVILEGED = "true"; # Enable for dind
    };

    extraOptions = [
      # "--privileged" # Enable for dind
      "--net=behind-nginx"
    ];
  };
}
