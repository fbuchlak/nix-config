{
  my,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = lib.flatten [

    ./desktop.nix
    ./hardware-configuration.nix
    (map my.lib.config.file [
      "host/_common/core"
      "host/_common/optional/boot/loader/systemd-boot.nix"
      "host/_common/optional/boot/uefi.nix"
      "host/_common/optional/audio"
    ])
    (import (my.lib.config.file "host/_common/optional/disk/layout/tmpfs-root+luks-encrypted-btrfs.nix")
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

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  networking = {
    hostName = "vesna";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  system.stateVersion = "24.05";

}
