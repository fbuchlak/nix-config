{ pkgs, ... }:
{

  # TODO: Split configuration

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