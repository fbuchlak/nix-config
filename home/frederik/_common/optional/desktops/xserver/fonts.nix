{ pkgs, ... }:
{

  home.packages = with pkgs; [
    liberation_ttf
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [
        "Liberation Serif"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Ubuntu"
        "Noto Color Emoji"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  persist.cache.symlinkDirectories = [ ".cache/fontconfig" ];

}
