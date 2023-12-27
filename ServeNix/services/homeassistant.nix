{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.homeassistant = {
    image = "lscr.io/linuxserver/homeassistant:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      # "8123:8123" # WebUI
    ];

    volumes = [
      "homeassistant_config:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Berlin";
    };

    extraOptions = [
      "--net=behind-nginx"
      "--device=/dev/ttyUSB0:/dev/ttyUSB0" # Sonoff Zigbee Stick
    ];
  };
}
