{ pkgs, inputs, ... }:
{

  # TODO: fetch config from https://github.com/fbuchlak/SimpleNvim

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
  };

  programs.neovim = {
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
      unzip
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
      biome
      marksman
    ];
  };

  # TODO: Split directory configuration
  persist.home.directories.config = [ "nvim" ];
  persist.home.directories.state = [ "nvim" ];
  persist.home.directories.data = [ "nvim" ];

  persist.cache.directories.cache = [
    "nvim"
    "pip"
    "lua-language-server"
  ];

}
