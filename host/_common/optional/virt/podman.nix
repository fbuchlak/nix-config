{ pkgs, ... }:
{

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  environment.systemPackages = with pkgs; [
    podman-tui
    podman-compose
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

}
