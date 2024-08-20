# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2d1b1f62-f008-4562-906e-5a63d854b18b";
      fsType = "ext4";
    };

    "/home/christoph/ssd" = {
      device = "/dev/disk/by-uuid/ff42f57c-cd45-41ea-a0ee-640e638b38bc";
      fsType = "ext4";
    };

    # Synology DS223j

    "/media/synology-syncthing" = {
      device = "192.168.86.15:/volume1/DockerVolumes";
      fsType = "nfs";
    };

    # SG Exos Mirror Shares

    "/media/Movie" = {
      device = "192.168.86.20:/mnt/SG Exos Mirror 18TB/Movie";
      fsType = "nfs";
    };

    "/media/Show" = {
      device = "192.168.86.20:/mnt/SG Exos Mirror 18TB/Show";
      fsType = "nfs";
    };

    "/media/TV-Usenet" = {
      device = "192.168.86.20:/mnt/SG Exos Mirror 18TB/Usenet";
      fsType = "nfs";
    };

    "/media/TV-Music" = {
      device = "192.168.86.20:/mnt/SG Exos Mirror 18TB/Music";
      fsType = "nfs";
    };

    # WD Blue Stripe Shares

    "/media/Stash-Video" = {
      device = "192.168.86.20:/mnt/WD Blue Stripe 2T/Video";
      fsType = "nfs";
    };

    "/media/Stash-Picture" = {
      device = "192.168.86.20:/mnt/WD Blue Stripe 2T/Picture";
      fsType = "nfs";
    };

    "/media/Stash-Clips" = {
      device = "192.168.86.20:/mnt/WD Blue Stripe 2T/Clips";
      fsType = "nfs";
    };

    "/media/Stash-Usenet" = {
      device = "192.168.86.20:/mnt/WD Blue Stripe 2T/Usenet";
      fsType = "nfs";
    };
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
