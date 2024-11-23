{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ nvme-cli ];
}
