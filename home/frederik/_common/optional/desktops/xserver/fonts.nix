{ pkgs, ... }:
{

  home.packages = with pkgs; [
    liberation_ttf
    ubuntu_font_family
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
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

  persist.cache.directories.cache = [ "fontconfig" ];

}
