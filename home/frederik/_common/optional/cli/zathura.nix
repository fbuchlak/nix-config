_: {

  programs.zathura = {
    enable = true;
    catppuccin.enable = true;
    options = {
      "selection-clipboard" = "clipboard";
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
