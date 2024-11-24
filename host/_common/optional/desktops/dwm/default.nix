{ pkgs, ... }:
{

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  environment.systemPackages = with pkgs; [
    st
    dwm
    dmenu
  ];

}
