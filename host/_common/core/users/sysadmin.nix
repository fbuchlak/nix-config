{
  my,
  pkgs,
  config,
  ...
}:
let
  inherit (my.vars) sysadmin;
in
{

  config = {

    users.groups.${sysadmin} = {
      name = sysadmin;
      members = [ sysadmin ];
    };

    users.users.${sysadmin} = {
      group = sysadmin;
      password = "changeme";
      isNormalUser = true;
      extraGroups =
        [ "wheel" ]
        ++ my.lib.user.filterGroups config [
          sysadmin
          "users"
          "git"
          "audio"
          "video"
          "docker"
          "networkmanager"
        ];
    };

    programs.zsh.enable = true;
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [

      wget
      curl
      rsync

      neovim
      ripgrep

    ];
  };

}
