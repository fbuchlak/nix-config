{
  my,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    ./temporary.nix
    ./hardware-configuration.nix

    (map my.lib.config.path [
      "host/_common/core"
      "host/_common/optional/boot/loader/systemd-boot.nix"
      "host/_common/optional/boot/uefi.nix"
      "host/_common/optional/audio"
      "host/_common/optional/desktops/dwm"
      "host/_common/optional/virt/podman.nix"
    ])

    (import (my.lib.config.path "host/_common/optional/disk/nvme.nix"))
    (import (my.lib.config.path "host/_common/optional/disk/layout/tmpfs-root+luks-encrypted-btrfs.nix")
      {
        inherit my lib inputs;
        deviceMain = "/dev/nvme0n1"; # WD_BLACK SN850X 1TB
        deviceExtra = "/dev/nvme1n1"; # Samsung 990 EVO 2TB
        efiSize = "1G";
        tmpfsSize = "8G";
        swapSize = "16G";
        withTmpVolume = false;
      }
    )

  ];

  # Users
  home-manager.users.frederik = import (my.lib.config.path "home/frederik/vesna.nix");

  # System
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Machine specific persistence
  persist.system.directories = [ "/etc/NetworkManager/system-connections" ];

  # Networking
  networking = {
    hostName = "vesna";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  system.stateVersion = "24.05";

}
