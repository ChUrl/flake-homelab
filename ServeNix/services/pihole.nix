{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    autoStart = true;

    dependsOn = [];

    ports = [
      "53:53/tcp"
      "53:53/udp"
      # "67:67/udp" # Only for DHCP server
      # "3080:80/tcp" # Webinterface
    ];

    volumes = [
      "pihole_config:/etc/pihole"
      "pihole_dnsmasq:/etc/dnsmasq.d"
    ];

    environment = {
      TZ = "Europe/Berlin";
      # WEBPASSWORD = "";
      FTLCONF_LOCAL_IPV4 = "192.168.86.25";
    };

    extraOptions = [
      # "--cap-add=NET_ADMIN" # Only for DHCP server
      # "--net=host" # For DHCP broadcast
      "--net=behind-nginx"
    ];
  };
}
