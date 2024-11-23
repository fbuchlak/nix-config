{ lib, ... }:
{

  boot.loader = {
    grub.enable = lib.mkForce false;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

}
