{ config, pkgs, inputs, ... }:

{
  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # User packages
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    git
    htop
    curl
    wget
    tree
    python314
    python313Packages.pip
    imagemagick
    android-tools
    gimp
    libreoffice
    git-lfs
    vlc
    kitty
    departure-mono
    sc-controller
    font-awesome
  ] ++ [ # make Dependencies
  dtc 
  ncurses
  bison 
  flex
  bc
  openssl
  libelf
  elfutils
  zlib
  perl
  pkgsCross.aarch64-multiplatform.stdenv.cc
  ] ++ [ # LazyVim Dependencies
    gcc
    gnumake
    nodejs
    unzip
    ripgrep
    fd
  ];

  # Install VSCode
  programs.vscode.enable = true;

  # Flatpak configuration (package is in configuration.nix)
  xdg.enable = true;

  home.sessionVariables = {
    XDG_DATA_DIRS =
      "$HOME/.local/share/flatpak/exports/share:"
      + "/var/lib/flatpak/exports/share:"
      + "$XDG_DATA_DIRS";
  };

  # Declarative Kitty config (Orange/Orwellian Theme)
  home.file.".config/kitty" = {
    source = ../dotfiles/kitty;
    recursive = true;
    force = true;
  };

  # Declarative Starship config
  home.file.".config/starship.toml" = {
    source = ../dotfiles/starship/starship.toml;
  };

  # Neovim With LazyVim
  programs.neovim = {
      enable = true;
      defaultEditor = true;
 };

  home.file.".config/nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
  };

  # Fish tweaks
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "nh os switch /home/taxmalalas0001/nix-config";
      hmconf = "nvim ~/nix-config/home-manager/home.nix";
      flakeconf = "nvim ~/nix-config/flake.nix";
      sysconf = "nvim ~/nix-config/nixos/configuration.nix";
      gitadd = "git add .";
      gitcom = "git commit -m";
      gitpush = "git push";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx NIXPKGS_ALLOW_UNFREE 1
    '';
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };


  # State version (IMPORTANT: match your NixOS one)
  home.stateVersion = "25.11";
}
