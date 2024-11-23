{ pkgs, ... }:
{

  # TODO: Change DE

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    dmenu
    dwm
    st
  ];
}
