{ my, pkgs, ... }:
let
  inherit (my.lib.files) patches;
  xresourcesPath = ".config/x11/xresources";
in
{

  imports = [ ./fonts.nix ];

  nixpkgs.overlays = [
    (_final: prev: {
      dmenu = prev.dmenu.overrideAttrs {
        version = "5.3";
        patches = patches ./patches/dmenu/5.3;
      };
      dwm = prev.dwm.overrideAttrs {
        version = "6.5";
        patches = patches ./patches/dwm/6.5;
      };
      st = prev.st.overrideAttrs {
        version = "0.9.2";
        patches = patches ./patches/st/0.9.2;
      };
    })
  ];

  home.file."${xresourcesPath}".source = ./xresources;
  home.packages = with pkgs; [

    st
    dwm
    dmenu
    dwmblocks

    arandr
    xclip
    scrot
    dunst
    libnotify

  ];

  home.file.".xinitrc".source = pkgs.writeShellScript ".xinitrc" ''
    export _JAVA_AWT_WM_NONREPARENTING=1

    runcmd () {
        cmd=$(echo $1 | awk '{print $1;}')
        if command -v $cmd &> /dev/null; then
            killall $cmd &> /dev/null
            eval "$1" &> /dev/null &
        fi
    }

    ${pkgs.xorg.xset}/bin/xset r rate 400 75
    ${pkgs.xorg.xrdb}/bin/xrdb -merge ${xresourcesPath}
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 96
    ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${my.lib.config.path "blob/wallpaper/blue-and-white-sky-with-stars.jpg"} || true

    runcmd ${pkgs.dunst}/bin/dunst
    runcmd ${pkgs.xcompmgr}/bin/xcompmgr
    runcmd ${pkgs.unclutter}/bin/unclutter
    runcmd ${pkgs.dwmblocks}/bin/dwmblocks

    pidof -sx dwm >/dev/null || ${pkgs.dwm}/bin/dwm
  '';

}
