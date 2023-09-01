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
    ./services/fileflows.nix
    ./services/homepage.nix
    ./services/hydra.nix
    ./services/jellyfin.nix
    ./services/jellyseerr.nix
    ./services/portainer.nix
    ./services/prowlarr.nix
    ./services/radarr.nix
    ./services/sabnzbd.nix
    ./services/sonarr.nix
    ./services/stash.nix
    ./services/wireguard_vps.nix
  ];

  # Bootloader.
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    loader.grub.useOSProber = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = false;
    };
  };

  networking.hostName = "servenix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
      glances
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

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    ntp.enable = true;
    qemuGuest.enable = true;
  };

  networking.firewall = {
    # Open ports in the firewall.
    allowedTCPPorts = [];
    allowedUDPPorts = [];
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
