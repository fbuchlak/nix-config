{ pkgs, ... }:
{

  # TODO: Split configuration

  environment.systemPackages = with pkgs; [
    openvpn

    pv
    zip
    unzip
    entr

    qpdf
    dos2unix
    dnsutils

    gimp
    libreoffice
    simplescreenrecorder
  ];

}
