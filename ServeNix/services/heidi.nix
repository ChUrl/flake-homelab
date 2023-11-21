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
      "--net=behind-nginx"
    ];
  };
}
