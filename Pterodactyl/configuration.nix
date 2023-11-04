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

    # Include Services
    ./services/pterodactyl.nix
    ./services/wings.nix
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

  # hardware = {
  #   opengl = {
  #     enable = true;
  #     driSupport = true;
  #     driSupport32Bit = true;
  #   };

  #   nvidia = {
  #     modesetting.enable = true;
  #     powerManagement.enable = false; # Experimental option, maybe this is the reason fileflows fails after some time?
  #     open = false;
  #     nvidiaSettings = false;
  #   };
  # };

  networking = {
    hostName = "pterodactyl"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.86.35";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.86.5";
    nameservers = [
      "192.168.86.5"
    ];
  };

  systemd.services.init-behind-nginx-docker-network = {
    description = "Create a docker network bridge for pterodactyl.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  
    serviceConfig.Type = "oneshot";
    script = let
      dockercli = "${config.virtualisation.docker.package}/bin/docker";
      network = "pterodactyl";
    in ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${dockercli} network ls | grep ${network} || true)
      if [ -z "$check" ]; then
        ${dockercli} network create ${network}
      else
        echo "${network} already exists in docker"
      fi
    '';
  };

  systemd.services.init-behind-nginx-docker-network = {
    description = "Create a docker network bridge for wings.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  
    serviceConfig.Type = "oneshot";
    script = let
      dockercli = "${config.virtualisation.docker.package}/bin/docker";
      network = "wings";
    in ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${dockercli} network ls | grep ${network} || true)
      if [ -z "$check" ]; then
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
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  home-manager.users.christoph = {pkgs, ...}: {
    home.packages = with pkgs; [
      lazygit
      keychain
      alejandra
      nnn
      busybox

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
      # enableNvidia = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
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
      # videoDrivers = ["nvidia"];
    };

    # Trims the journal if it gets too large
    journald.extraConfig = ''
      SystemMaxUse=50M
    '';

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    ntp.enable = true;
    qemuGuest.enable = true;
  };

  networking.firewall = {
    # Open ports in the firewall.
    allowedTCPPorts = [
      # Pterodactyl Panel
      80
      443
    ];
    allowedUDPPorts = [
      # Pterodactyl Panel
      80
      443
    ];
    allowedTCPPortRanges = [
      # Pterodactyl Node/Servers
      {
        from = 10000;
        to = 10099;
      }
    ];
    allowedUDPPortRanges = [
      # Pterodactyl Node/Servers
      {
        from = 10000;
        to = 10099;
      }
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
