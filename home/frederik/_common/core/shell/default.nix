{ my, ... }:
{

  imports = my.lib.files.nix ./.;

  home.shellAliases = {

    ls = "ls -hN --color=auto";
    ll = "ls -alF --group-directories-first";

    cal = "cal -m --color=auto";
    diff = "diff --color=auto";
    grep = "grep --color=auto";

    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -Iv";
    df = "df -h";
    free = "free -h";

    mkd = "mkdir -pv";

  };

}
