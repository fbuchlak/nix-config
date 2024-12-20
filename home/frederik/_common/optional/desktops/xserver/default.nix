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

  imports = [
    ./fonts.nix
    ./dwmblocks.nix
  ];

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
    dmenu
    xdg-terminal-exec

    arandr
    xclip
    scrot
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
    source ${xdg.configPath config "x11/xsession"}

    export _JAVA_AWT_WM_NONREPARENTING=1

    runcmd () {
        cmd=$(basename "$(echo $1 | awk '{print $1;}')")
        ${pkgs.killall}/bin/killall "$cmd" &> /dev/null
        if command -v "$1" &> /dev/null; then
            eval "$1" &> /dev/null &
        fi
    }

    ${pkgs.xorg.xset}/bin/xset r rate 400 75
    ${pkgs.xorg.xrdb}/bin/xrdb -merge ${xdg.configPath config "x11/xresources"}
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 96
    ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${my.lib.config.path "blob/wallpaper/blue-and-white-sky-with-stars.jpg"} || true
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap "us,sk" -option caps:backspace # TODO: This should be defined by home.keyboard

    runcmd ${pkgs.dunst}/bin/dunst
    runcmd ${pkgs.xcompmgr}/bin/xcompmgr
    runcmd ${pkgs.unclutter}/bin/unclutter
    runcmd ${pkgs.dwmblocks}/bin/dwmblocks

    pidof -sx dwm >/dev/null || ${pkgs.dwm}/bin/dwm
  '';

  xsession = {
    enable = true;
    scriptPath = xdg.configPathRel config "x11/xsession";
    profilePath = xdg.configPathRel config "x11/xprofile";
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "alt + q" = "${pkgs.dunst}/bin/dunstctl close";
      "alt + w" = "${pkgs.dunst}/bin/dunstctl action";
      "alt + e" = "${pkgs.dunst}/bin/dunstctl history-pop";
      "super + space" = "${pkgs.xkb-switch}/bin/xkb-switch -n ; pkill -RTMIN+12 dwmblocks";
      "@XF86AudioMute" = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle ; ; pkill -RTMIN+11 dwmblocks";
      "@XF86AudioLowerVolume" = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%- unmute ; pkill -RTMIN+11 dwmblocks";
      "@XF86AudioRaiseVolume" = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%+ unmute ; pkill -RTMIN+11 dwmblocks";
      "@XF86AudioMicMute" = "${pkgs.alsa-utils}/bin/amixer -q set Capture toggle ; pkill -RTMIN+10 dwmblocks";
    };
  };

  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      global = {
        follow = "keyboard";
        origin = "bottom-right";
        font = "Monospace 12";
      };
    };
  };
  # INFO: It's not worth it to dunst run as a service.
  #       There are several problems with xsession/dbus.
  systemd.user.services.dunst = {
    Service.ExecStart = lib.mkForce [ "echo 'dunst.service is disabled'" ];
  };

  xdg.desktopEntries.st = {
    name = "St";
    genericName = "St";
    categories = [ "TerminalEmulator" ];
    exec = "st";
  };

}
