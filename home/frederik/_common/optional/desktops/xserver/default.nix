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
    ./cursor.nix
    ./fonts.nix
    ./dwmblocks.nix
  ];

  nixpkgs.overlays = [
    (_final: prev: {
      dmenu = prev.dmenu.overrideAttrs {
        src = builtins.fetchurl {
          url = "https://dl.suckless.org/tools/dmenu-5.3.tar.gz";
          sha256 = "0pvr6da1v7hmbnacpgxcxv1sakg1nckmw347xhwrhx1dzpk573qs";
        };
        patches = patches ./patches/dmenu/5.3;
      };
      dwm = prev.dwm.overrideAttrs {
        src = builtins.fetchurl {
          url = "https://dl.suckless.org/dwm/dwm-6.5.tar.gz";
          sha256 = "0acpl05rg6rg6nrg3rv4kp388iqzp1n6dhin30a97yzjm6zrxmr1";
        };
        patches = patches ./patches/dwm/6.5;
      };
      st = prev.st.overrideAttrs (prev: {
        src = builtins.fetchurl {
          url = "https://dl.suckless.org/st/st-0.9.2.tar.gz";
          sha256 = "0js9z5kn8hmpxzfmb2g6zsy28zkpg88j3wih5wixc89b8x7ms8bb";
        };
        patches = patches ./patches/st/0.9.2;
        buildInputs = (prev.buildInputs or [ ]) ++ [ pkgs.xorg.libXcursor ];
      });
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

  home.sessionVariables.TERMINAL = lib.mkDefault "${pkgs.st}/bin/st";
  home.sessionVariables.XINITRC = xdg.configPath config "x11/xinitrc";
  home.sessionVariables.XAUTHORITY = "\${XDG_RUNTIME_DIR:-\"/run/user/$(id -u)\"}/Xauthority";
  xdg.configFile."x11/xresources".source = ./xresources;
  xdg.configFile."x11/xinitrc".source =
    with pkgs;
    writeShellScript "xinitrc" ''
      source ${xdg.configPath config "x11/xsession"}

      export _JAVA_AWT_WM_NONREPARENTING=1

      runcmd () {
          cmd=$(${coreutils}/bin/basename "$1" | ${gawk}/bin/awk '{print $1;}')
          ${procps}/bin/pkill -9 "$cmd" &> /dev/null
          if command -v "$1" &> /dev/null; then
              eval "$1" &> /dev/null &
          fi
      }

      ${xorg.xset}/bin/xset r rate 400 75
      ${xorg.xrdb}/bin/xrdb -merge ${xdg.configPath config "x11/xresources"}
      ${xorg.xrandr}/bin/xrandr --dpi 96
      ${xwallpaper}/bin/xwallpaper --zoom ${my.lib.config.path "blob/wallpaper/blue-and-white-sky-with-stars.jpg"}
      ${xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      ${xorg.setxkbmap}/bin/setxkbmap "us,sk" -option "caps:backspace" # TODO: This should be defined by home.keyboard

      runcmd ${dunst}/bin/dunst
      runcmd ${xcompmgr}/bin/xcompmgr
      runcmd ${xbanish}/bin/xbanish
      runcmd ${dwmblocks}/bin/dwmblocks

      ${procps}/bin/pidof -sx dwm >/dev/null || ${dwm}/bin/dwm
    '';

  xsession = {
    enable = true;
    scriptPath = xdg.configPathRel config "x11/xsession";
    profilePath = xdg.configPathRel config "x11/xprofile";
  };

  services.sxhkd = {
    enable = true;
    keybindings =
      with pkgs;
      let
        dunstBin = "${dunst}/bin/dunstctl";
        amixerBin = "${alsa-utils}/bin/amixer";
        execWithReloadSignal =
          command: signal: "${command} ; ${procps}/bin/pkill -RTMIN+${toString signal} dwmblocks";
      in
      {
        "alt + q" = "${dunstBin} close";
        "alt + w" = "${dunstBin} action";
        "alt + e" = "${dunstBin} history-pop";
        "super + space" = execWithReloadSignal "${xkb-switch}/bin/xkb-switch -n" 12;
        "@XF86AudioMute" = execWithReloadSignal "${amixerBin} -q set Master toggle" 11;
        "@XF86AudioLowerVolume" = execWithReloadSignal "${amixerBin} -q set Master 5%- unmute" 11;
        "@XF86AudioRaiseVolume" = execWithReloadSignal "${amixerBin} -q set Master 5%+ unmute" 11;
        "@XF86AudioMicMute" = execWithReloadSignal "${amixerBin} -q set Capture toggle" 10;
      };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
        origin = "bottom-right";
        font = "Monospace 12";
      };
    };
  };
  catppuccin.dunst.enable = true;
  # INFO: It's not worth it to run dunst as a service.
  #       There are several problems with xsession/dbus.
  systemd.user.services.dunst = {
    Service.ExecStart = lib.mkForce [ "${pkgs.coreutils}/bin/echo 'dunst.service is disabled'" ];
  };

  xdg.desktopEntries.st = {
    name = "St";
    genericName = "St";
    categories = [ "TerminalEmulator" ];
    exec = "${pkgs.st}/bin/st";
  };

}
