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
      shell = pkgs.zsh;
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
          "networkmanager"
        ];
    };

    programs.zsh.enable = true;
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      rsync
      fd
      fzf
      ripgrep
    ];
  };

}
