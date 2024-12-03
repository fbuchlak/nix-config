{ my, pkgs, ... }:
let
  inherit (my.lib.files) patches;
in
{

  nixpkgs.overlays = [
    (_final: prev: {
      dwmblocks = prev.dwmblocks.overrideAttrs {
        src = builtins.fetchGit {
          url = "https://github.com/UtkarshVerma/dwmblocks-async";
          ref = "main";
          rev = "fe538a7a2fc52e991a553bd76719735141658844";
        };
        patches = patches ./patches/dwmblocks-async;
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [
          pkgs.xorg.libxcb
          pkgs.xorg.xcbutil
        ];
      };
    })
  ];

  home.packages = [

    (pkgs.writeShellScriptBin "dwmblocks-script-cpu" ''
      ${pkgs.sysstat}/bin/mpstat | awk '
          $3 ~ /CPU/ {
              for (i = 1; i <= NF; i++) {
                  if ($i ~ /%idle/) field=i
              }
          }
          $3 ~ /all/ {
              printf(" %d%%\n", 100 - $field)
          }
      '
    '')

    (pkgs.writeShellScriptBin "dwmblocks-script-memory" ''
      free -mh --si | grep '^Mem:' | awk '{printf "󰍛 %s\n",$3}'
    '')

    (pkgs.writeShellScriptBin "dwmblocks-script-alsa-input" ''
      device="''${1:-Capture}"

      case $BLOCK_BUTTON in
          1) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" nocap ;;
          3) if ${pkgs.alsa-utils}/bin/amixer sget "$device" | grep -q off ; then
                  ${pkgs.alsa-utils}/bin/amixer -q sset "$device" cap
                  ${pkgs.libnotify}/bin/notify-send -u critical "Output [$device]" "Device started capturing"
              fi
              ;;
      esac

      if ${pkgs.alsa-utils}/bin/amixer sget "$device" | grep -q off ; then
          icon="󰍭";
      else
          icon="󰍬";
      fi

      printf "%s\n" $icon
    '')

    (pkgs.writeShellScriptBin "dwmblocks-script-alsa-output" ''
      device="''${1:-Master}"

      if [[ -n $BLOCK_BUTTON ]]; then
          case $BLOCK_BUTTON in
              1) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" "20%+" unmute ;;
              2) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" toggle ;;
              3) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" "20%-" ;;
              4) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" 1%+ ;;
              5) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" 1%- ;;
          esac
      fi

      vol=$(awk -F "[][]" '/%/ { print 0+$2; exit; }' <(${pkgs.alsa-utils}/bin/amixer sget "$device"))
      volicon="󰝟";

      if ! ${pkgs.alsa-utils}/bin/amixer sget "$device" | grep -q off ; then
          case 1 in
              $((vol >= 75)) ) volicon="󰕾" ;;
              $((vol >= 40)) ) volicon="󰖀" ;;
              $((vol >= 1)) ) volicon="󰕿" ;;
      * ) ${pkgs.alsa-utils}/bin/amixer -q sset "$device" mute ;;
      esac
      fi

      printf "%s %03s%%%s\n" "$volicon" "$vol" "$2"
    '')

    (pkgs.writeShellScriptBin "dwmblocks-script-date" ''
      case $BLOCK_BUTTON in
          1) ${pkgs.libnotify}/bin/notify-send "󰃭 Date detail" "\n''$(date +"Date: %F%nTime: %T%nDay: %u%nWeek: %V%n")" ;;
      esac

      date +"󰃭 %R"
    '')

    (pkgs.writeShellScriptBin "dwmblocks-script-battery" ''
      bstatus () {
          dest=$(mktemp)
          echo "Battery#Capacity#Status" > $dest
          for battery in /sys/class/power_supply/BAT?*; do
              echo "$(basename "$battery")#$(cat "$battery/capacity")%#$(cat "$battery/status")" >> $dest
          done
          column -t -s'#' $dest
          rm $dest
      }

      case $BLOCK_BUTTON in
          3) ${pkgs.libnotify}/bin/notify-send "Battery status" "$(bstatus)" ;;
      esac

      for battery in /sys/class/power_supply/BAT?*; do
          [ -n "$bat_status" ] && printf " | "

          case "$(cat "$battery/status" 2>&1)" in
              "Full"|"Charging") bat_status="󱊦" ;;
              "Discharging") bat_status="󱊤" ;;
              "Not charging") bat_status="󱉝" ;;
              *) bat_status="󱉝" ;;
          esac

          printf "%s" $bat_status
      done && printf "\n"
    '')

  ];

}
