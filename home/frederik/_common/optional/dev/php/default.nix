{ pkgs-system, ... }:
{

  imports = [
    ./phpactor.nix
    ./symfony.nix
  ];

  home.packages = with pkgs-system.unstable; [
    ### core packages
    php84
    psysh
    php84Packages.composer
    ### style
    mago
    php84Packages.phpmd
    php84Packages.psalm
    php84Packages.phpstan
    # php84Packages.php-cs-fixer
    php84Packages.php-codesniffer
    ### tools
    php84Packages.box
    php84Packages.phing
    php84Packages.castor
    php84Packages.grumphp
  ];

  persist.home.directories.data = [ "composer" ];
  persist.cache.directories.cache = [ "composer" ];

  home.shellAliases = {
    phpr = "psysh";
  };

}
