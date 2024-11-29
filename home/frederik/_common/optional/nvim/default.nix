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
  persist.home.symlinkDirectories = [ ".config/nvim" ];
  persist.data.symlinkDirectories = [
    ".local/share/nvim"
    ".local/state/nvim"
  ];
  persist.cache.symlinkDirectories = [
    ".cache/nvim"
    ".cache/phpactor"
    ".cache/lua-language-server"
    ".cache/composer"
    ".cache/pip"
    ".cache/go-build"
    ".cargo" # WARN: This isn't cache only
  ];

}
