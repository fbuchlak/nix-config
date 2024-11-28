_: {

  programs.zathura = {
    enable = true;
    options = {
      "selection-clipboard" = "clipboard";
      "completion-bg" = "#EED49F"; # c03
      "completion-fg" = "#8AADF4"; # c04
      "completion-highlight-bg" = "#EED49F"; # c03
      "completion-highlight-fg" = "#8AADF4"; # c04
      "default-bg" = "#24273A"; # cBG
      "default-fg" = "#CAD3F5"; # cFG
      "highlight-active-color" = "#8AADF4"; # c04
      "highlight-color" = "#EED49F"; # c03
      "inputbar-bg" = "#24273A"; # cBG
      "inputbar-fg" = "#CAD3F5"; # cFG
      "notification-bg" = "#24273A"; # cBG
      "notification-error-bg" = "#24273A"; # cBG
      "notification-error-fg" = "#CAD3F5"; # cFG
      "notification-fg" = "#CAD3F5"; # cFG
      "notification-warning-bg" = "#24273A"; # cBG
      "notification-warning-fg" = "#CAD3F5"; # cFG
      "recolor-darkcolor" = "#CAD3F5"; # cFG
      "recolor-lightcolor" = "#24273A"; # cBG
      "statusbar-bg" = "#24273A"; # cBG
      "statusbar-fg" = "#CAD3F5"; # cFG
    };
    mappings = {
      "[normal] i" = "recolor";
      "[fullscreen] i" = "recolor";
      "[presentation] i" = "recolor";
      "[normal] F" = "toggle_fullscreen";
      "[fullscreen] F" = "toggle_fullscreen";
      "[normal] P" = "toggle_presentation";
      "[presentation] P" = "toggle_presentation";
      "[normal] u" = "scroll half-up";
      "[normal] d" = "scroll half-down";
      "[fullscreen] u" = "scroll half-up";
      "[fullscreen] d" = "scroll half-down";
      "[normal] J" = "zoom out";
      "[normal] K" = "zoom in";
      "[fullscreen] J" = "zoom out";
      "[fullscreen] K" = "zoom in";
      "[presentation] h" = "navigate previous";
      "[presentation] j" = "navigate next";
      "[presentation] k" = "navigate previous";
      "[presentation] ;" = "navigate next";
    };
  };

}
