# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>

    # DNS (required for internet)
    # ./services/adguard.nix # NOTE: Runs on ThinkNix
    # ./services/pihole.nix

    # My own stuff
    # ./services/airsignal.nix
    ./services/heidi.nix
    ./services/formula10.nix
    ./services/formula11.nix

    # General
    ./services/authelia.nix
    ./services/gitea.nix
    ./services/gitea-runner.nix
    # ./services/homeassistant.nix # Replaced by HAOS
    # ./services/homepage.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/kopia.nix
    ./services/nextcloud.nix
    ./services/nginx-proxy-manager.nix
    ./services/paperless.nix
    ./services/portainer.nix
    # ./services/uptime-kuma.nix
    ./services/whats-up-docker.nix
    # ./services/wireguard-vps.nix # NOTE: Runs on ThinkNix
  ];

  # Bootloader.
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    loader.grub.useOSProber = true;

    # NOTE: I think this needs a separate EFI partition?
    # loader.systemd-boot = {
    #   enable = true;
    #   configurationLimit = 5;
    #   editor = false;
    #   # canTouchEfiVariables = true;
    #   # efiSysMountPoint = "/boot";
    # };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # Experimental option, maybe this is the reason fileflows fails after some time?
      open = false;
      nvidiaSettings = false;
    };
  };

  networking = {
    hostName = "servenix"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
    enableIPv6 = true;

    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.168.86.25";
          prefixLength = 24;
        }
      ];

      ipv6.addresses = [
        {
	  address = "fd00::19"; # 25 in hex
	  prefixLength = 120;
	}
      ];
    };

    defaultGateway = "192.168.86.5";
    defaultGateway6 = "fd00::5";

    nameservers = [
      # "127.0.0.1"
      # "8.8.8.8"
      "192.168.86.26"
      "fd00::1a" # 26 in hex
    ];
  };

  systemd.services.init-behind-nginx-docker-network = {
    description = "Create a docker network bridge for all services behind nginx-proxy-manager.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  
    serviceConfig.Type = "oneshot";
    script = let
      dockercli = "${config.virtualisation.docker.package}/bin/docker";
      network = "behind-nginx";
    in ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${dockercli} network ls | grep ${network} || true)
      if [ -z "$check" ]; then
        # TODO: Disable IP masquerading to show individual containers in AdGuard/Pi-Hole
        #       - Disabling this prevents containers from having internet connection. DNS issue?
        # ${dockercli} network create -o "com.docker.network.bridge.enable_ip_masquerade"="false" ${network}

        # ${dockercli} network create --ipv6 --gateway="2000::1" --subnet="2000::/80" ${network}
        ${dockercli} network create ${network}
      else
        echo "${network} already exists in docker"
      fi
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christoph = {
    isNormalUser = true;
    description = "Christoph";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  users.users.git = {
    uid = 500;
    group = "git";
    isNormalUser = false;
    isSystemUser = true;
    description = "Gitea User";
    extraGroups = ["docker"];
    shell = pkgs.fish;
  };

  home-manager.users.christoph = {pkgs, ...}: {
    home.packages = with pkgs; [
      lazygit
      keychain
      alejandra
      nnn
      busybox
      glances
      ffmpeg
      ripgrep

      docker-compose
    ];

    programs = {
      fish = {
        enable = true;
      };

      git = {
        enable = true;
        userEmail = "christoph.urlacher@protonmail.com";
        userName = "Christoph Urlacher";
      };

      keychain = {
        enable = true;
        enableFishIntegration = true;
        agents = ["ssh"];
        keys = ["id_ed25519"];
      };

      starship = {
        enable = true;
        enableFishIntegration = true;
      };

      yt-dlp = {
        enable = true;
      };
    };

    home.stateVersion = "23.05";
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableNvidia = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
      daemon.settings = {
        # ipv6 = true; # TODO: Resulted in slowdowns for some services?
	# fixed-cidr-v6 = "2001::/80";

        dns = [
          # TODO: Does this circumvent my DNS for each container?
          #       It might improve gitea actions though...
          "8.8.8.8"
	  # "2001:4860:4860::8888"

          # TODO: Might prevent containers from having DNS?
          # "127.0.0.1"
          # "192.168.86.25"
        ];

	# Allow access via tcp socket (for homepage)
	hosts = [
	  "tcp://0.0.0.0:2375"
	  "unix:///var/run/docker.sock"
	];
      };
    };
    oci-containers.backend = "docker";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    helix
    git
  ];

  programs = {
    firejail.enable = true;
    fish.enable = true;
    git.enable = true;
    neovim.enable = true;
    # fuse.userAllowOther = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services = {
    # Configure keymap in X11
    xserver = {
      layout = "us";
      xkbVariant = "altgr-intl";
      videoDrivers = ["nvidia"];
    };

    # Trims the journal if it gets too large
    journald.extraConfig = ''
      SystemMaxUse=50M
    '';

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    ntp.enable = true;
    qemuGuest.enable = true;
    # TODO: Might prevent containers from having working DNS
    # resolved.fallbackDns = ["8.8.8.8"];
  };

  networking.firewall = {
    # Open ports in the firewall.
    allowedTCPPorts = [
      # PiHole requires these ports, as it's running in --net=host mode
      53
      80

      3000 # Gitea runner needs to reach local gitea instance
    ];
    allowedUDPPorts = [
      # PiHole requires these ports, as it's running in --net=host mode
      53
      67 # PiHole DHCP

      3000 # Gitea runner needs to reach local gitea instance
    ];
    # Or disable the firewall altogether.
    enable = true;

    trustedInterfaces = [
      "docker0"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
