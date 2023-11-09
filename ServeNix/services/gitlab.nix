{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.gitlab = {
    image = "gitlab/gitlab-ce";
    autoStart = true;

    dependsOn = [
      # "pihole"
    ];

    ports = [
      # "80:80"
      # "443:443"
      "2222:22" # SSH
    ];

    volumes = [
      "gitlab_config:/etc/gitlab"
      "gitlab_logs:/var/log/gitlab"
      "gitlab_data:/var/opt/gitlab"
    ];

    environment = {
      GITLAB_OMNIBUS_CONFIG = "external_url 'https://gitlab.local.chriphost.de:443'; gitlab_rails['gitlab_shell_ssh_port'] = 2222;";
    };

    extraOptions = [
      # "--gpus=all"
      "--net=behind-nginx"
      "--shm-size=256m"
    ];
  };
}
