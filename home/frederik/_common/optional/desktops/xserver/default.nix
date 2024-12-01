{
  my,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (my.lib) xdg files;
  inherit (files) patches;
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

  home.packages = with pkgs; [

    st
    dwm
    dmenu
    dwmblocks
    xdg-terminal-exec

    arandr
    xclip
    scrot
    dunst
    libnotify

  ];

  home.shellAliases = {
    xclip = "xclip -sel clip";
  };

  home.sessionVariables.TERMINAL = lib.mkDefault "st";
  home.sessionVariables.XINITRC = xdg.configPath config "x11/xinitrc";
  home.sessionVariables.XAUTHORITY = "\${XDG_RUNTIME_DIR:-\"/run/user/$(id -u)\"}/Xauthority";
  xdg.configFile."x11/xresources".source = ./xresources;
  xdg.configFile."x11/xinitrc".source = pkgs.writeShellScript "xinitrc" ''
    export _JAVA_AWT_WM_NONREPARENTING=1

    runcmd () {
        cmd=$(echo $1 | awk '{print $1;}')
        if command -v $cmd &> /dev/null; then
            killall $cmd &> /dev/null
            eval "$1" &> /dev/null &
        fi
    }

    ${pkgs.xorg.xset}/bin/xset r rate 400 75
    ${pkgs.xorg.xrdb}/bin/xrdb -merge ${xdg.configPath config "x11/xresources"}
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 96
    ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${my.lib.config.path "blob/wallpaper/blue-and-white-sky-with-stars.jpg"} || true

    runcmd ${pkgs.dunst}/bin/dunst
    runcmd ${pkgs.xcompmgr}/bin/xcompmgr
    runcmd ${pkgs.unclutter}/bin/unclutter
    runcmd ${pkgs.dwmblocks}/bin/dwmblocks

    pidof -sx dwm >/dev/null || ${pkgs.dwm}/bin/dwm
  '';

  xdg.desktopEntries.st = {
    name = "St";
    genericName = "St";
    categories = [ "TerminalEmulator" ];
    exec = "st";
  };

}
