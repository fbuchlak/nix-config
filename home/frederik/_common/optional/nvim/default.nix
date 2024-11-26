{
  my,
  pkgs,
  config,
  ...
}:
{

  # TODO: fetch config from https://github.com/fbuchlak/SimpleNvim

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    extraPackages = with pkgs; [
      fd
      fzf
      ripgrep
      go
      gcc
      cargo
      cmake
      gnumake
      python3
      tree-sitter
      php84
      php84Packages.composer
      nodejs
      nixfmt-rfc-style
      stylua
      lua-language-server
      typos-lsp
    ];
  };

  # TODO: Split directory configuration
  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".config/nvim";
        method = "symlink";
      }
    ];
    "${my.vars.persistence.data.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".local/share/nvim";
        method = "symlink";
      }
      {
        directory = ".local/state/nvim";
        method = "symlink";
      }
    ];
    "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".cache/nvim";
        method = "symlink";
      }
      {
        directory = ".cache/phpactor";
        method = "symlink";
      }
      {
        directory = ".cache/lua-language-server";
        method = "symlink";
      }
      {
        directory = ".cache/composer";
        method = "symlink";
      }
      {
        directory = ".cache/pip";
        method = "symlink";
      }
      {
        directory = ".cache/go-build";
        method = "symlink";
      }
      {
        directory = ".cargo"; # WARN: This isn't cache only
        method = "symlink";
      }
    ];
  };

}
