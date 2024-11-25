{ pkgs, ... }:
{

  # TODO: Split configuration

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    gnumake
    openvpn
    awscli2
    postgresql
    mysql84
    php84
    php84Packages.composer
    nodejs
    yarn
  ];

}
