{
  my,
  lib,
  inputs,
  deviceMain ? throw "\"deviceMain\" is required!",
  deviceExtra ? throw "\"deviceExtra\" is required!",
  efiSize ? throw "\"efiSize\" is required!",
  tmpfsSize ? throw "\"tmpfsSize\" is required!",
  swapSize ? throw "\"swapSize\" is required!",
  withTmpVolume ? throw "\"withTmpVolume\" is required!",
  ...
}:
let
  inherit (my.vars) persistence;

  luksContent = {
    type = "luks";
    passwordFile = "/tmp/disko-password";
    extraFormatArgs = [
      "--type luks2"
      "--cipher aes-xts-plain64"
      "--hash sha512"
      "--iter-time 5000"
      "--key-size 256"
      "--pbkdf argon2id"
      "--use-random"
    ];
    settings = {
      allowDiscards = true;
      crypttabExtraOpts = [
        "fido2-device=auto"
        "token-timeout=10"
      ];
    };
  };

  btrfsContent = {
    type = "btrfs";
    extraArgs = [ "-f" ];
  };

  mkPersistence = name: {
    vol = "@${name}";
    mnt = "/${name}";
  };
  mkSubvolume = persistence: opts: {
    ${persistence.vol} = {
      mountpoint = persistence.mnt;
      mountOptions = lib.flatten [
        opts
        "noatime"
      ];
    };
  };

  hasDeviceExtra = builtins.isString deviceExtra;
  dataSubvolume = mkSubvolume persistence.data "compress=zstd:4";

in
{

  imports = [
    inputs.disko.nixosModules.default
    ../persistence.nix
    ../btrfs.nix
  ];

  disko.devices = {

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=${tmpfsSize}"
        "mode=755"
      ];
    };

    disk = {

      main = {
        type = "disk";
        device = deviceMain;
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              priority = 1;
              type = "EF00";
              name = "ESP";
              size = efiSize;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            encryptedSwap = {
              size = swapSize;
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };

            luks = {
              size = "100%";
              content = lib.recursiveUpdate luksContent {
                name = "root_encrypted";
                extraOpenArgs = [ "--timeout 10" ];
                content = lib.recursiveUpdate btrfsContent {
                  subvolumes =
                    mkSubvolume (mkPersistence "nix") "compress-force=zstd:1"
                    // mkSubvolume persistence.system "compress-force=lzo"
                    // mkSubvolume persistence.cache "compress-force=lzo"
                    // mkSubvolume persistence.logs "compress-force=zstd:3"
                    // mkSubvolume persistence.virt "compress=lzo"
                    // mkSubvolume persistence.home "compress-force=zstd:1"
                    // lib.optionalAttrs (!hasDeviceExtra) dataSubvolume
                    // lib.optionalAttrs withTmpVolume (mkSubvolume (mkPersistence "tmp") "compress=no");
                };
              };
            };

          };
        };
      };

      extra = lib.mkIf hasDeviceExtra {
        type = "disk";
        device = deviceExtra;
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = lib.recursiveUpdate luksContent {
                name = "data_encrypted";
                initrdUnlock = true;
                content = lib.recursiveUpdate btrfsContent {
                  subvolumes = dataSubvolume;
                };
              };
            };
          };
        };
      };

    };

  };

}
