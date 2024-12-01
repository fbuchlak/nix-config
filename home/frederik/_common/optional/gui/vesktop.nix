{
  my,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
  nixcordEnabled = config.programs.nixcord.enable;
  vesktopEnabled = nixcordEnabled && config.programs.nixcord.vesktop.enable;
  persistentHome = my.vars.persistence.home.mnt;
in
{

  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = lib.mkDefault true;
    discord.enable = lib.mkForce false;
    vesktop = {
      enable = true;
      package = pkgs.vesktop;
    };
    config = {
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
    };
  };

  # https://github.com/KaylorBen/nixcord/issues/24
  xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
    discordBranch = "stable";
    tray = false;
    arRPC = false;
    minimizeToTray = false;
    splashColor = "oklab(0.89908 -0.00192907 -0.0048306)";
    splashBackground = "oklab(0.321044 -0.000249296 -0.00927344)";
  };

  # INFO: Create vesktop initial state to ignore "firstLaunch" configuration.
  # After that let vesktop manage it's own state.
  # See https://github.com/Vencord/Vesktop/issues/220
  home.activation.create-vesktop-initial-state = lib.mkIf vesktopEnabled (
    let
      vesktopConfigDir = "${persistentHome}/${lib.removePrefix "/" (xdg.configPath config "vesktop")}";
      vesktopStatePersistentPath = "${persistentHome}/${lib.removePrefix "/" (xdg.configPath config "vesktop/state.json")}";
    in
    lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      if [ ! -f "${vesktopStatePersistentPath}" ]; then
          if [ ! -d "${vesktopConfigDir}" ]; then
              mkdir -p "${vesktopConfigDir}"
          fi
          echo '{"firstLaunch":false}' > "${vesktopStatePersistentPath}"
      fi
    ''
  );

  persist.home.files.config = [ "vesktop/state.json" ];
  persist.home.directories.config = [ "vesktop/sessionData" ];

}
