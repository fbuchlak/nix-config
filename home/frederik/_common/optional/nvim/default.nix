{ pkgs, ... }:
{

  # TODO: fetch config from https://github.com/fbuchlak/SimpleNvim

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
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
      nil
      statix
      deadnix
      stylua
      lua-language-server
      typos-lsp
    ];
  };

  # TODO: Split directory configuration
  persist.home.directories.config = [ "nvim" ];
  persist.home.directories.state = [ "nvim" ];
  persist.home.directories.data = [ "nvim" ];

  persist.cache.directories.home = [ ".cargo" ]; # WARN: This isn't cache only
  persist.cache.directories.cache = [
    "nvim"
    "phpactor"
    "lua-language-server"
    "composer"
    "pip"
    "go-build"
  ];

}
