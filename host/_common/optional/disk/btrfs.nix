{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ compsize ];
  virtualisation.containers.storage.settings.storage.driver = "btrfs";

}
