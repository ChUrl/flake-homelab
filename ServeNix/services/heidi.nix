{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.heidi = {
    image = "gitea.vps.chriphost.de/christoph/discord-heidi:latest";
    autoStart = true;

    dependsOn = [];

    ports = [];

    volumes = [
      "/home/christoph/heidi-sounds:/sounds:ro"
    ];

    environment = {
      DISCORD_TOKEN = (builtins.readFile ./heidi.discord_token);
    };

    extraOptions = [
      "--init" # Make an init process take up PID 1, to make python receive the SIGTERM
      "--net=behind-nginx"
    ];
  };
}
